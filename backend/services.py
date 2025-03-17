import json
import os
import google.generativeai as genai
import re
from dotenv import load_dotenv

load_dotenv()

# Google Gemini API 키 설정
api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    raise ValueError("GEMINI_API_KEY가 설정되지 않았습니다. .env 파일을 확인하세요.")

genai.configure(api_key=api_key)

# 멘토 데이터 불러오기
with open("mentors.json", "r", encoding="utf-8") as file:
    mentors = json.load(file)

def split_sentences(text, max_length=100):
    """긴 문장을 적절한 크기로 나누어 리스트로 반환"""
    sentences = re.split(r'(?<=[.!?])\s+', text)  # 문장 단위로 나누기
    chunks = []
    current_chunk = ""

    for sentence in sentences:
        if len(current_chunk) + len(sentence) < max_length:
            current_chunk += sentence + " "
        else:
            chunks.append(current_chunk.strip())
            current_chunk = sentence + " "

    if current_chunk:
        chunks.append(current_chunk.strip())

    return chunks

def get_mentor_response(mentor_id: str, user_question: str):
    """Google Gemini API를 활용하여 특정 멘토처럼 답변 생성"""
    if mentor_id not in mentors:
        return {"responses": ["이 멘토에 대한 정보가 없습니다."]}

    mentor = mentors[mentor_id]

    # ✅ 더 대화형 스타일로 유도하는 프롬프트
    prompt = (
        f"너는 {mentor['name']}이야. "
        f"너의 대화 스타일은 {mentor['style']}이야. "
        f"질문자는 너의 제자이며, 너는 너의 {mentor['category']} 능력을 가르쳐. "
        f"친근하고 자연스럽게 대화를 이어가며 설명해줘. "
        f"너무 긴 답변을 하지 말고, 한 번에 짧은 메시지로 대답하고 다음 메시지를 기다려줘. "
        f"번호 매기기는 피하고, 마치 대화하듯 답변해줘. "
        f"\n\n질문: {user_question}"
    )

    try:
        print(f"💡 [DEBUG] Gemini API 호출 시작: {mentor['name']}, 질문: {user_question}")

        # Gemini 모델 세션 생성
        model = genai.GenerativeModel("gemini-2.0-flash")
        chat = model.start_chat()

        response = chat.send_message(prompt)

        # ✅ 문장을 나누어 여러 개의 응답으로 반환
        split_responses = split_sentences(response.text.strip(), max_length=100)

        return {"responses": split_responses}  # ✅ 리스트 형태로 반환

    except Exception as e:
        print(f"❌ [ERROR] Gemini API 오류: {e}")
        return {"responses": [f"오류 발생: {str(e)}"]}
