from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(
    title="PlaceMux API",
    version="1.0.0"
)

class RecommendationRequest(BaseModel):
    location: str
    category: str

@app.get("/")
def root():
    return {
        "service": "PlaceMux API",
        "version": "1.0.0"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy"
    }

@app.post("/recommend")
def recommend(request: RecommendationRequest):
    return {
        "location": request.location,
        "category": request.category,
        "recommendation": f"Best {request.category} in {request.location}",
        "score": 95
    }