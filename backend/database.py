from typing import Dict, List, Optional
from datetime import datetime
import uuid
from models import Note, NoteCreate, NoteUpdate

class InMemoryDatabase:
    """Simple in-memory database for storing notes"""
    
    def __init__(self):
        self.notes: Dict[str, Note] = {}
    
    def create_note(self, note_data: NoteCreate) -> Note:
        """Create a new note"""
        note_id = str(uuid.uuid4())
        now = datetime.utcnow()
        
        note = Note(
            id=note_id,
            title=note_data.title,
            body=note_data.body,
            created_at=now,
            updated_at=now
        )
        
        self.notes[note_id] = note
        return note
    
    def get_note(self, note_id: str) -> Optional[Note]:
        """Get a note by ID"""
        return self.notes.get(note_id)
    
    def get_all_notes(self, search: Optional[str] = None) -> List[Note]:
        """Get all notes, optionally filtered by search term"""
        notes = list(self.notes.values())
        
        if search:
            search_lower = search.lower()
            notes = [
                note for note in notes 
                if search_lower in note.title.lower() or search_lower in note.body.lower()
            ]
        
        # Sort by updated_at descending (most recent first)
        notes.sort(key=lambda x: x.updated_at, reverse=True)
        return notes
    
    def update_note(self, note_id: str, note_data: NoteUpdate) -> Optional[Note]:
        """Update an existing note"""
        if note_id not in self.notes:
            return None
        
        note = self.notes[note_id]
        
        # Update only provided fields
        if note_data.title is not None:
            note.title = note_data.title
        if note_data.body is not None:
            note.body = note_data.body
        
        note.updated_at = datetime.utcnow()
        
        self.notes[note_id] = note
        return note
    
    def delete_note(self, note_id: str) -> bool:
        """Delete a note by ID"""
        if note_id in self.notes:
            del self.notes[note_id]
            return True
        return False
    
    def get_notes_count(self) -> int:
        """Get total number of notes"""
        return len(self.notes)

# Global database instance
db = InMemoryDatabase()

# Add some sample data for testing
sample_notes = [
    NoteCreate(title="Welcome to Notes App", body="This is your first note! You can create, edit, and delete notes easily."),
    NoteCreate(title="Shopping List", body="- Milk\n- Bread\n- Eggs\n- Apples\n- Coffee"),
    NoteCreate(title="Meeting Notes", body="Discussed project timeline and deliverables. Next meeting scheduled for Friday."),
]

for sample_note in sample_notes:
    db.create_note(sample_note)