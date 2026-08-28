# Etape 1 : construction des dependances
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Etape 2 : image finale, sans outillage de construction
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
