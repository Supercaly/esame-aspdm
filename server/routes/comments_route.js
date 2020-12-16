const router = require('express').Router();
const {body, param, validationResult} = require('express-validator');
const {idValidator, idSanitizer, arrayValidator, populateTask} = require('../utils');
const Task = require('../model/task_model');

// Creates a new Comment inside a Task with given id
router.post("/", [
    body('task').custom(idValidator).customSanitizer(idSanitizer),
    body('comment.content').notEmpty(),
    body('comment.author').custom(idValidator).customSanitizer(idSanitizer),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const newComment = {
            content: req.body.comment.content,
            author: req.body.comment.author,
        };
        const tasks = await Task.findOneAndUpdate({_id: req.body.task}, {
            $push: {
                comments: newComment,
            }
        }, {new: true}).populate(populateTask).exec();
        res.json(tasks);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Deletes a comment inside a task with given id.
router.delete("/", [
    body('task').custom(idValidator).customSanitizer(idSanitizer),
    body('user').custom(idValidator).customSanitizer(idSanitizer),
    body('comment').custom(idValidator).customSanitizer(idSanitizer),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const task = await Task.findOneAndUpdate({
            _id: req.body.task,
        }, {
            $pull: {
                comments: {
                    author: req.body.user,
                    _id: req.body.comment,
                }
            }
        }, {new: true}).populate(populateTask).exec()
        res.json(task);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Edits the content of a comment under a task
router.patch("/", [
    body('task').custom(idValidator).customSanitizer(idSanitizer),
    body('user').custom(idValidator).customSanitizer(idSanitizer),
    body('comment').custom(idValidator).customSanitizer(idSanitizer),
    body('content').isString().notEmpty(),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const task = await Task.findOneAndUpdate({_id: req.body.task},
            {$set: {"comments.$[elem].content": req.body.content}},
            {
                multi: false,
                arrayFilters: [{"elem._id": req.body.comment, "elem.author": req.body.user}],
                new: true,
            }
        ).populate(populateTask).exec()
        res.json(task);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

router.post("/like", [
    body('task').custom(idValidator).customSanitizer(idSanitizer),
    body('user').custom(idValidator).customSanitizer(idSanitizer),
    body('comment').custom(idValidator).customSanitizer(idSanitizer),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const task = await Task.findById(req.body.task);
        const comment = task.comments.id(req.body.comment);
        // The user already liked the comment
        if (comment.like_users.includes(req.body.user)) {
            // Remove the like
            comment.like_users.remove(req.body.user);
        } else if (comment.dislike_users.includes(req.body.user)) {
            // Remove the like
            comment.dislike_users.remove(req.body.user);
        } else {
            // Add the like
            comment.like_users.push(req.body.user);
        }
        await comment.save();
        console.log(typeof comment);
        res.json(task);
    } catch (e) {
        console.error(e);
        res.status(500).json({error: `No Task found with id ${req.params.id}`});
    }
});

module.exports = router;