const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
app.use(bodyParser.json());

// Connect database
mongoose.connect("mongodb://localhost:27017/database", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useFindAndModify: false,
})
    .then(() => console.log("Database connected!"))
    .catch(e => console.error(`Error connecting to database: ${e}`));
mongoose.connection.on('error', e => console.error(e));

// Setup Routes
app.use("/api/", require('./routes/users_route'));
app.use("/api/list", require('./routes/list_tasks_route'));
app.use("/api/task", require('./routes/task_route'));
app.use("/api/comment", require('./routes/comments_route'));

// Listen to server
app.listen(5000, () => console.log("Listening server on port 3000!"));