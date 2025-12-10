# Notes API v1.0.0

## Endpoints

### GET /api/notes
Retrieve all notes with optional search filtering

**Response:**
```json
{'success': True, 'message': 'Retrieved X notes', 'data': [{'id': 'uuid', 'title': 'string', 'body': 'string', 'created_at': 'datetime', 'updated_at': 'datetime'}], 'total': 'number'}
```

### GET /api/notes/{note_id}
Retrieve a specific note by ID

**Response:**
```json
{'success': True, 'message': 'Note retrieved successfully', 'data': {'id': 'uuid', 'title': 'string', 'body': 'string', 'created_at': 'datetime', 'updated_at': 'datetime'}}
```

### POST /api/notes
Create a new note

**Request Body:**
```json
{'title': 'string (required, 1-200 chars)', 'body': 'string (required)'}
```

**Response:**
```json
{'success': True, 'message': 'Note created successfully', 'data': {'id': 'uuid', 'title': 'string', 'body': 'string', 'created_at': 'datetime', 'updated_at': 'datetime'}}
```

### PUT /api/notes/{note_id}
Update an existing note

**Request Body:**
```json
{'title': 'string (optional)', 'body': 'string (optional)'}
```

**Response:**
```json
{'success': True, 'message': 'Note updated successfully', 'data': {'id': 'uuid', 'title': 'string', 'body': 'string', 'created_at': 'datetime', 'updated_at': 'datetime'}}
```

### DELETE /api/notes/{note_id}
Delete a note by ID

**Response:**
```json
{'success': True, 'message': 'Note deleted successfully'}
```

### GET /api/notes/stats/summary
Get summary statistics about notes

**Response:**
```json
{'success': True, 'message': 'Notes statistics retrieved', 'data': {'total_notes': 'number'}}
```

