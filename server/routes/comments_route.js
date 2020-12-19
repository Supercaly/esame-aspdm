const router = require('express').Router();
const {body, validationResult} = require('express-validator');
const {idValidator, idSanitizer, populateTask} = require('../utils');
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

// Likes a given comments
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
        const likes = comment.like_users;

        let updated;
        if (likes.includes(req.body.user)) {
            updated = await Task.findOneAndUpdate({
                _id: req.body.task,
                "comments._id": req.body.comment
            }, {
                $pull: {"comments.$.like_users": req.body.user}
            }, {new: true})
        } else {
            updated = await Task.findOneAndUpdate({
                _id: req.body.task,
                "comments._id": req.body.comment
            }, {
                $pull: {"comments.$.dislike_users": req.body.user},
                $addToSet: {"comments.$.like_users": req.body.user}
            }, {new: true});
        }
        res.json(updated);
    } catch (e) {
        console.error(e);
        res.status(500).json({error: e});
    }
});

// Dislikes a given comments
router.post("/dislike", [
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
        const dislikes = comment.dislike_users;

        let updated;
        if (dislikes.includes(req.body.user)) {
            updated = await Task.findOneAndUpdate({
                _id: req.body.task,
                "comments._id": req.body.comment
            }, {
                $pull: {"comments.$.dislike_users": req.body.user}
            }, {new: true})
        } else {
            updated = await Task.findOneAndUpdate({
                _id: req.body.task,
                "comments._id": req.body.comment
            }, {
                $pull: {"comments.$.like_users": req.body.user},
                $addToSet: {"comments.$.dislike_users": req.body.user}
            }, {new: true});
        }
        res.json(updated);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

module.exports = router;