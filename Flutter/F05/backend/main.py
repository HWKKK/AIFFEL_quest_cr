from fastapi import FastAPI, File, UploadFile
import tensorflow as tf
import numpy as np
from tensorflow.keras.preprocessing import image
import io
import os

app = FastAPI()

# ✅ 모델 경로 설정
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "models", "vgg16.h5")

# ✅ 모델 파일이 존재하는지 확인
if not os.path.exists(MODEL_PATH):
    raise FileNotFoundError(f"🚨 모델 파일을 찾을 수 없습니다: {MODEL_PATH}")

# ✅ VGG16 모델 로드
model = tf.keras.models.load_model(MODEL_PATH)

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    contents = await file.read()
    img = image.load_img(io.BytesIO(contents), target_size=(224, 224))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0  # 정규화

    predictions = model.predict(img_array)
    class_id = np.argmax(predictions[0])  # 예측된 클래스
    confidence = np.max(predictions[0])  # 예측 확률

    # ✅ 해파리 판별 로직 추가
    is_jellyfish = "해파리" if class_id == 107 else "해파리가 아님"

    return {
        "class": is_jellyfish,
        "confidence": float(confidence)
    }
