const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    profile_color: {
        type: String,
        default: null,
        validate: {
            validator: function (v) {
                if (v === undefined || v === null) return true;
                return (/^#([0-9a-f]{6})$/i).test(v);
            },
            message: 'Invalid Color'
        },
    },
});

module.exports = mongoose.model('User', UserSchema);