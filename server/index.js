const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const cors = require('cors');
const admin = require('firebase-admin');
require('dotenv').config();

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    databaseURL: 'https://aspdm-project.firebaseio.com',
});

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Connect database
//const dbUri = `mongodb+srv://${process.env.USER}:${process.env.PWD}@${process.env.HOST}/${process.env.DB}?retryWrites=true&w=majority`
const dbUri = "mongodb://localhost:27017/database";
mongoose.connect(dbUri, {
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
app.use("/api/labels", require('./routes/label_route'));
app.get("/not", async  (req, res) => {
    console.log("ciao");
    await admin.messaging().send({
        topic: "newtask",
        notification: {title: "Ciao", body: "Test Test"},
        data: {task_id: "prova"}
    });
    res.sendStatus(200);
})
// Listen to server
app.listen(process.env.PORT, () => console.log(`Listening server on port ${process.env.PORT}!`));