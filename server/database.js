const path = require('path');
const Datastore = require('nedb');


const usersDatastore = new Datastore({
    filename: path.join(__dirname, ".data", "users.db"),
    autoload: true,
});

const db = {};
db.users = usersDatastore;

module.exports = db;