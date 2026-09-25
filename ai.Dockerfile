FROM alpine:3.20 AS unpack
RUN apk add --no-cache unzip
COPY bharatbhumi-render-package.zip /tmp/source.zip
RUN mkdir /src && unzip -q /tmp/source.zip -d /src

FROM python:3.12-slim
WORKDIR /app
COPY --from=unpack /src/backend/ai/ ./
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 10000
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
