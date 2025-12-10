from fastapi import APIRouter, HTTPException, Query
from typing import Optional
from models import Note, NoteCreate, NoteUpdate, NoteResponse, NotesListResponse
from database import db

router = APIRouter()

@router.get("/notes", response_model=NotesListResponse)
async def get_all_notes(search: Optional[str] = Query(None, description="Search term to filter notes")):
    """
    Retrieve all notes with optional search filtering.
    
    - **search**: Optional search term to filter notes by title or body content
    """
    try:
        notes = db.get_all_notes(search=search)
        return NotesListResponse(
            success=True,
            message=f"Retrieved {len(notes)} notes" + (f" matching '{search}'" if search else ""),
            data=notes,
            total=len(notes)
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to retrieve notes: {str(e)}")

@router.get("/notes/{note_id}", response_model=NoteResponse)
async def get_note(note_id: str):
    """
    Retrieve a specific note by ID.
    
    - **note_id**: The unique identifier of the note
    """
    note = db.get_note(note_id)
    if not note:
        raise HTTPException(status_code=404, detail="Note not found")
    
    return NoteResponse(
        success=True,
        message="Note retrieved successfully",
        data=note
    )

@router.post("/notes", response_model=NoteResponse, status_code=201)
async def create_note(note_data: NoteCreate):
    """
    Create a new note.
    
    - **title**: The note title (required, 1-200 characters)
    - **body**: The note content (required)
    """
    try:
        note = db.create_note(note_data)
        return NoteResponse(
            success=True,
            message="Note created successfully",
            data=note
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to create note: {str(e)}")

@router.put("/notes/{note_id}", response_model=NoteResponse)
async def update_note(note_id: str, note_data: NoteUpdate):
    """
    Update an existing note.
    
    - **note_id**: The unique identifier of the note
    - **title**: Optional new title for the note
    - **body**: Optional new content for the note
    """
    # Check if note exists
    if not db.get_note(note_id):
        raise HTTPException(status_code=404, detail="Note not found")
    
    # Validate that at least one field is provided
    if note_data.title is None and note_data.body is None:
        raise HTTPException(status_code=400, detail="At least one field (title or body) must be provided")
    
    try:
        updated_note = db.update_note(note_id, note_data)
        return NoteResponse(
            success=True,
            message="Note updated successfully",
            data=updated_note
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to update note: {str(e)}")

@router.delete("/notes/{note_id}")
async def delete_note(note_id: str):
    """
    Delete a note by ID.
    
    - **note_id**: The unique identifier of the note to delete
    """
    if not db.delete_note(note_id):
        raise HTTPException(status_code=404, detail="Note not found")
    
    return {
        "success": True,
        "message": "Note deleted successfully"
    }

@router.get("/notes/stats/summary")
async def get_notes_stats():
    """
    Get summary statistics about notes.
    """
    total_notes = db.get_notes_count()
    return {
        "success": True,
        "message": "Notes statistics retrieved",
        "data": {
            "total_notes": total_notes
        }
    }