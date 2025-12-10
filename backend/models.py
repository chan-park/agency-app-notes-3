from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
import uuid

class NoteBase(BaseModel):
    """Base model for note data"""
    title: str = Field(..., min_length=1, max_length=200, description="Note title")
    body: str = Field(..., description="Note content/body")

class NoteCreate(NoteBase):
    """Model for creating a new note"""
    pass

class NoteUpdate(BaseModel):
    """Model for updating an existing note"""
    title: Optional[str] = Field(None, min_length=1, max_length=200, description="Note title")
    body: Optional[str] = Field(None, description="Note content/body")

class Note(NoteBase):
    """Complete note model with metadata"""
    id: str = Field(..., description="Unique note identifier")
    created_at: datetime = Field(..., description="Note creation timestamp")
    updated_at: datetime = Field(..., description="Note last update timestamp")
    
    class Config:
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }

class NoteResponse(BaseModel):
    """Response model for note operations"""
    success: bool
    message: str
    data: Optional[Note] = None

class NotesListResponse(BaseModel):
    """Response model for listing notes"""
    success: bool
    message: str
    data: list[Note] = []
    total: int = 0