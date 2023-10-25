const mongoose = require('mongoose');

const TaskSchema = mongoose.Schema({
    author: {
        type: mongoose.Types.ObjectId,
        ref: "User",
        required: true,
    },
    title: {
        type: String,
        required: true,
    },
    description: String,
    creation_date: {
        type: Date,
        default: Date.now(),
    },
    archived: {
        type: Boolean,
        default: false,
    },
    expire_date: Date,
    labels: [{type: mongoose.Types.ObjectId, ref: "Label"}],
    members: [{type: mongoose.Types.ObjectId, ref: "User"}],
    checklists: [{
        title: {
            type: String,
            required: true,
        },
        items: [{
            item: {
                type: String,
                required: true,
            },
            complete: {
                type: Boolean,
                default: false,
            }
        }]
    }],
    comments: [{
        author: {
            type: mongoose.Types.ObjectId,
            ref: "User",
            required: true,
        },
        content: {
            type: String,
            required: true,
        },
        creation_date: {
            type: Date,
            default: Date.now(),
        },
        like_users: [{type: mongoose.Types.ObjectId, ref: "User"}],
        dislike_users: [{type: mongoose.Types.ObjectId, ref: "User"}],
    }]
});

module.exports = mongoose.model('Task', TaskSchema);