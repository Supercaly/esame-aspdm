const mongoose = require('mongoose');

const LabelSchema = mongoose.Schema({
    label: String,
    color: {
        type: String,
        validate: {
            validator: function (v) { return (/^#([0-9a-f]{6})$/i).test(v); },
            message: 'Invalid Color'
        },
        required: true,
    }
});

module.exports = mongoose.model('Label', LabelSchema);