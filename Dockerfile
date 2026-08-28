# Etape 1 : construction des dependances
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Etape 2 : execution des tests, echoue le build si un test echoue
FROM python:3.12-slim AS test
WORKDIR /app
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
RUN pip install --no-cache-dir --user pytest
COPY requirements.txt .
COPY app.py .
COPY test_app.py .
RUN pip install --no-cache-dir --user -r requirements.txt
RUN python -m pytest -v

# Etape 3 : image finale, sans outillage de construction ni de test
FROM python:3.12-slim
WORKDIR /app

# Utilisateur non privilegie
RUN useradd --create-home appuser
COPY --from=builder /root/.local /home/appuser/.local
COPY app.py .

RUN chown -R appuser:appuser /app
USER appuser
ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 8000
CMD ["python", "app.py"]
