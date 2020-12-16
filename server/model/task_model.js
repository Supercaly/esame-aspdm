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
    labels: [{
        label: String,
        color: {
            type: String,
            validate: {
                validator: function (v) { return (/^#([0-9a-f]{6})$/i).test(v); },
                message: 'Invalid Color'
            },
            required: true,
        }
    }],
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