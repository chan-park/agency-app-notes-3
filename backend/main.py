from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import notes

app = FastAPI(
    title="Notes API",
    description="A simple note-taking API with CRUD operations",
    version="1.0.0"
)

# Configure CORS for frontend access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your frontend domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(notes.router, prefix="/api", tags=["notes"])

@app.get("/")
async def root():
    """Root endpoint returning API information"""
    return {
        "message": "Notes API",
        "version": "1.0.0",
        "docs": "/docs"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)