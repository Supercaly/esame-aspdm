const router = require('express').Router();
const {populateTask} = require('../utils');
const Task = require('../model/task_model');

// Returns all the unarchived tasks
router.get("/", async (req, res) => {
    try {
        const tasks = await Task.find({archived: false})
            .populate(populateTask)
            .sort('-creation_date')
            .exec();
        res.json(tasks);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Returns all the archived tasks
router.get("/archived", async (req, res) => {
    try {
        const tasks = await Task.find({archived: true})
            .populate(populateTask)
            .sort('-creation_date')
            .exec();
        res.json(tasks);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

module.exports = router;