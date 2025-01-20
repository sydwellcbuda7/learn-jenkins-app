FROM mcr.microsoft.com/playwright:v1.39.0-jammy

RUN npm install -g netlify-cli

RUN npm -g install serve

RUN apt update

RUN apt install jq
