import os
from fastapi import FastAPI, File, UploadFile
import tensorflow as tf
import numpy as np
from tensorflow.keras.preprocessing import image
import io

app = FastAPI()

# ✅ 모델 경로를 OS에 맞게 자동 변환
MODEL_PATH = os.path.join("backend", "models", "vgg16.h5")

# ✅ 모델이 실제로 존재하는지 확인
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
    class_id = np.argmax(predictions[0])
    confidence = np.max(predictions[0])

    return {"class": int(class_id), "confidence": float(confidence)}
