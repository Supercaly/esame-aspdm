# API routes

## User

### GET /api/users

Returns all users in the database. 
Each user has only `name`, `email`, `profile_color`.

### GET /api/user/{userId}

Return `name`, `email`, `profile_color` of the user with given ***userId***.
If the user doesn't exist `null` will be returned instead.

### POST /api/users  
**// TODO: REMOVE THIS COMMAND!** 

Creates a new user with given name, email, password, profile_color. 
Returns the whole new `user`.

### POST /api/authenticate

Authenticate a user with given:

```json
{
  "email": "user_email",
  "password": "user_password"
}
```

Returns `null` if the email or password are not valid, otherwise returns `email`, `name`, `profile_color`.

## List Labels

### GET /api/labels

List all available labels by `label` and `color`.

## List Tasks

### GET /api/list

Return all the tasks that are not archived. The tasks are sorted by `creation_date`
in descending order. If there are no tasks it will return `[]`.

### GET /api/list/archived

Return all the archived tasks. The tasks are sorted by `creation_date`
in descending order. If there are no tasks it will return `[]`.

## Manipulate Task

### GET /api/task/{taskId}

Return a single task with given ***taskId***. 
If the task doesn't exist `null` is returned instead.

### POST /api/task

Creates a new task with given:

```json
{
  "title": "task_title",
  "description": "task_description",
  "author": "user_id",
  "members": [
    "user_ids"
  ],
  "labels": [
    "label_ids"
  ],
  "expire_date": "date",
  "checklists": [
    {
      "title": "checklist_title",
      "items": [
        "items text"
      ]
    }
  ]
}
```

The remaining fields of the task are auto-populated by the database. 
This will create a new task that *is not archived*, *has no comments*, *has checklists with un-checked items* and is created *now*. 
The new task is returned after his creation.

### PATCH /api/task

Updates a task with given id and body parameters:

```json
{
  "id": "task_id",
  "task": {
    "title": "task_title",
    "description": "task_description",
    "expire_date": "date",
    "members": [
      "user_ids"
    ],
    "labels": [
      "label_ids"
    ],
    "checklists": [
      {
        "title": "checklist_title",
        "items": {
          "item": "item",
          "checked": true
        }
      }
    ]
  }
}
```

### POST /api/task/archive

Archive/un-archive the task with given id. This operation is only possible if
the user doing that is the tasks' author, or a member; if the user doesn't satisfy 
this requirement the operation don't succeed and `null` is returned. 
If the operation succeed the updated task is returned.
The body parameter of this request are:

```json
{
  "task": "task_id",
  "user": "user_id",
  "archive": true
}
```

If archive is ***true*** the task will be archived, if it's ***false*** it'll be un-archived.

### POST /api/task/check

Marks as done a checklist's item under a given task. The parameters are: 

```json
{
  "user": "user_id",
  "task": "task_id",
  "checklist": "checklist_id",
  "item": "item_id",
  "checked": true
}
```

Returns `null` if the user is not the author or a member or if the item doesn't belong to the checklist or task.    

## Manipulate Comment

### POST /api/comment

Creates a new comment under the given task. The parameters are:

```json
{
  "task": "task_id",
  "comment": {
    "author": "user_id",
    "content": "comment_content"
  }
}
```

The updated task will be returned.

### DELETE /api/comment

Deletes a comment with given id under a given task. The parameters are:

```json
{
  "task": "task_id",
  "user": "user_id",
  "comment": "comment_id"
}
```

When the comment is removed successfully the updated document is returned.
If the user is not the author of the comment, or the comment doesn't exist the operation
will do nothing, and the document will be returned. If the task doesn't exist `null` will be returned. 

### PATCH /api/comment

Edits a comment with given id under a given task, The parametrs are:

```json
{
  "task": "task_id",
  "user": "user_id",
  "comment": "comment_id",
  "content": "new_comment_content"
}
```

When the comment is edited successfully the updated document is returned.
If the user is not the author of the comment, or the comment doesn't exist the operation
will do nothing, and the document will be returned. If the task doesn't exist `null` will be returned.

### POST /api/comment/like

Sets the given user as one that liked the given comment under a task.
If the user already liked the comment it will be removed form the likes.
The parameters are: 

```json
{
  "user": "user_id",
  "task": "task_id",
  "comment": "comment_id"
}
```

### POST /api/comment/dislike

Sets the given user as one that disliked the given comment under a task.
If the user already disliked the comment it will be removed form the dislikes.
The parameters are:

```json
{
  "user": "user_id",
  "task": "task_id",
  "comment": "comment_id"
}
```

# Error handling

Each request will return HTTP's status code `500` if there was an internal error, 
this means that something went wrong with the database. The HTTP's status code `400`
is returned when the parameters of the query (be that query parameter, url inlined or 
body parameter) are not valid.
In both cases a JSON object is attached to the response with a field `errors`.
If the request succeeded HTTP's status `200` is emitted.  