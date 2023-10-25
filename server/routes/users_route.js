const router = require('express').Router();
const {body, param, validationResult} = require('express-validator');
const {idValidator, idSanitizer, colorValidator} = require('../utils');
const User = require('../model/user_model.js');

// Returns all users.
router.get("/users", async (req, res) => {
    try {
        const users = await User.find({}, 'name email profile_color').exec();
        res.json(users);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Return a single user with given id
router.get("/user/:userId", [
    param('userId').custom(idValidator).customSanitizer(idSanitizer)
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const user = await User.findById(req.params.userId, 'name email profile_color').exec();
        res.json(user);
    } catch (e) {
        console.error(e);
        res.status(404).json({errors: e});
    }
});

// Authenticate a user with given email and password
router.post("/authenticate", [
    body('email').isEmail(),
    body('password').notEmpty(),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const user = await User.findOne({
            email: req.body.email,
            password: req.body.password,
        }, 'name email profile_color').exec();
        res.json(user);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

// Creates a new user.
router.post("/users", [
    body('name').notEmpty(),
    body('email').isEmail(),
    body('password').notEmpty(),
    body('profile_color').custom(colorValidator)
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty())
        return res.status(400).json({errors: errors.array()});

    try {
        const user = await User.create({
            name: req.body.name,
            email: req.body.email,
            password: req.body.password,
            profile_color: req.body.profile_color,
        });
        res.json(user);
    } catch (e) {
        console.error(e);
        res.status(500).json({errors: e});
    }
});

module.exports = router;