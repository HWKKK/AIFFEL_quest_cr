from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from services import get_mentor_response
from fastapi.responses import JSONResponse

app = FastAPI()

# 사용자 입력을 받을 모델 정의
class ChatRequest(BaseModel):
    mentor_id: str
    question: str

@app.get("/")
def read_root():
    return {"message": "AI 멘토링 API"}

@app.post("/chat")
def chat(request: ChatRequest):
    """사용자의 질문을 받아 멘토 AI의 응답을 반환"""
    try:
        response = get_mentor_response(request.mentor_id, request.question)
        return JSONResponse(content=response, media_type="application/json; charset=utf-8")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
