const ObjectId = require('mongoose').Types.ObjectId;

const idValidator = (v) => ObjectId.isValid(v);
const idSanitizer = (v) => new ObjectId(v);
const arrayValidator = (v) => v === undefined || v === null || Array.isArray(v);
const colorValidator = (v) => v === undefined || v === null || (/^#([0-9a-f]{6})$/i).test(v);


exports.idValidator = idValidator;
exports.idSanitizer = idSanitizer;
exports.arrayValidator = arrayValidator;
exports.colorValidator = colorValidator;

exports.populateTask = {
    path: 'author members comments labels',
    populate: {path: 'author like_users dislike_users'},
}