const router = require('express').Router();
const Label = require('../model/label_model.js');

// Return all labels
router.get("/", async (req, res) => {
    try {
        const labels = await Label.find({});
        res.json(labels);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

module.exports = router;