FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY requirements.txt .

RUN python -m pip install --no-cache-dir --upgrade \
    pip \
    "setuptools>=84.0.0" \
    "wheel>=0.48.0" \
    && python -m pip install --no-cache-dir -r requirements.txt

RUN python -m pip --version \
    && python -m pip show setuptools wheel

COPY app.py .
COPY templates/ templates/
COPY static/ static/

EXPOSE 5000

CMD ["gunicorn", "app:app", \
     "--bind", "0.0.0.0:5000", \
     "--access-logfile", "-", \
     "--error-logfile", "-"]