from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(
    title="PlaceMux API",
    version="1.0.0"
)

# Recommendation Model
class RecommendationRequest(BaseModel):
    location: str
    category: str

# Prediction Model
class PredictionRequest(BaseModel):
    skills: list[str]

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

@app.post("/predict")
def predict(data: PredictionRequest):

    recommendations = [
        "SOC Analyst",
        "Threat Intelligence Analyst",
        "Digital Forensics Analyst"
    ]

    return {
        "input_skills": data.skills,
        "recommendations": recommendations,
        "confidence": 0.95
    }


from app.redis_client import redis_client

@app.get("/redis-test")
def redis_test():

    redis_client.set("status", "working")

    return {
        "redis_value": redis_client.get("status")
    }