const admin = require('firebase-admin');

// Send a notification when a new task is created
const sendNotification = async (newTask) => {
    const title = newTask.title;
    const authorName = (newTask.author != null) ? newTask.author.name : null;

    const notificationTitle = `New task from ${authorName}`;
    const notificationBody = `"${title}"`;
    const message = {
        topic: "newtask",
        notification: {
            title: notificationTitle,
            body: notificationBody,
        },
        data: {
            task_id: newTask._id.toString(),
        }
    }
    try {
        await admin.messaging().send(message);
    } catch (e) {
        console.error("Error occurred while sending notification " + message + " " + e);
    }
}

module.exports = sendNotification;