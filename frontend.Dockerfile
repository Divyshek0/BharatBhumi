FROM alpine:3.20 AS unpack
RUN apk add --no-cache unzip
COPY bharatbhumi-render-package.zip /tmp/source.zip
RUN mkdir /src && unzip -q /tmp/source.zip -d /src

FROM node:20-alpine
WORKDIR /app
COPY --from=unpack /src/frontend /app
RUN npm ci && npm run build
ENV HOSTNAME=0.0.0.0
EXPOSE 10000
CMD ["npm", "start"]
