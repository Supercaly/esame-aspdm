const router = require('express').Router();
const {body, param, validationResult} = require('express-validator');
const {idValidator, idSanitizer, arrayValidator, populateTask} = require('../utils');
const Task = require('../model/task_model');
const fcmUtils = require('../fcm_utils');

// Returns a Task with given id
router.get("/:taskId", [
    param('taskId').custom(idValidator).customSanitizer(idSanitizer)
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const tasks = await Task.findById(req.params.taskId)
            .populate(populateTask)
            .exec();
        res.json(tasks);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Creates a new Task with parameters from body
router.post("/", [
    body('title').isString().notEmpty(),
    body('description').optional({nullable: true}).isString(),
    body('expire_date').optional({nullable: true}).isISO8601(),
    body('author').custom(idValidator).customSanitizer(idSanitizer),
    body('members').custom(arrayValidator),
    body('labels').custom(arrayValidator),
    body('checklists').custom(arrayValidator),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const task = await Task.create({
            author: req.body.author,
            title: req.body.title,
            description: req.body.description,
            expire_date: req.body.expire_date,
            members: (req.body.members != null) ? req.body.members : [],
            labels: (req.body.labels != null) ? req.body.labels : [],
            checklists: (req.body.checklists != null) ? req.body.checklists.map(checklist => {
                return {
                    title: checklist.title,
                    items: (checklist.items != null) ? checklist.items.map(item => {
                        return {
                            item: item,
                        }
                    }) : [],
                }
            }) : [],
        });
        if (task != null) {
            const newTask = await Task.findById(task._id).populate(populateTask).exec();
            fcmUtils(newTask);
            res.json(newTask);
        } else
            res.json(task);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Update a Task with parameters from body
router.patch("/", [
    body('id').custom(idValidator).customSanitizer(idSanitizer),
    body('task.title').isString().notEmpty(),
    body('task.description').optional({nullable: true}).isString(),
    body('task.expire_date').optional({nullable: true}).isISO8601(),
    body('task.members').custom(arrayValidator),
    body('task.labels').custom(arrayValidator),
    body('task.checklists').custom(arrayValidator),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const update = req.body.task;
        const task = await Task.findByIdAndUpdate(req.body.id, {
            $set: {
                title: update.title,
                description: update.description,
                expire_date: update.expire_date,
                members: (update.members != null) ? update.members : [],
                labels: (update.labels != null) ? update.labels : [],
                checklists: (update.checklists != null) ? update.checklists.map(checklist => {
                    return {
                        title: checklist.title,
                        items: (checklist.items != null) ? checklist.items.map(item => {
                            return {
                                item: item.item,
                                complete: item.checked,
                            }
                        }) : [],
                    }
                }) : [],
            }
        }, {new: true}).populate(populateTask).exec();
        res.json(task);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Marks a Task as archived
router.post("/archive", [
    body('user').custom(idValidator).customSanitizer(idSanitizer),
    body('task').custom(idValidator).customSanitizer(idSanitizer),
    body('archive').isBoolean(),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const task = await Task.findOneAndUpdate(
            {_id: req.body.task, $or: [{author: req.body.user}, {members: req.body.user}]},
            {archived: req.body.archive},
            {new: true})
            .populate(populateTask)
            .exec();
        res.json(task);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Checks a checklist's item on a given task
router.post("/check", [
    body('task').custom(idValidator).customSanitizer(idSanitizer),
    body('user').custom(idValidator).customSanitizer(idSanitizer),
    body('checklist').custom(idValidator).customSanitizer(idSanitizer),
    body('item').custom(idValidator).customSanitizer(idSanitizer),
    body('checked').isBoolean(),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const task = await Task.findOneAndUpdate({
            _id: req.body.task,
            $or: [{author: req.body.user}, {members: req.body.user}],
            "checklists": {
                $elemMatch: {
                    "_id": req.body.checklist,
                    "items._id": req.body.item,
                }
            },
        }, {
            $set: {
                "checklists.$[check].items.$[item].complete": req.body.checked
            }
        }, {
            multi: false,
            arrayFilters: [{"check._id": req.body.checklist}, {"item._id": req.body.item}],
            new: true,
        }).populate(populateTask).exec();
        res.json(task);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

module.exports = router;
