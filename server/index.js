const express = require('express');
const bodyParser = require('body-parser');
require('./database');

const app = express();
app.use(bodyParser.json());

app.use("/api/users", require('./routes/users_route'));

app.listen(3000, () => console.log("Listening server on port 3000!"));