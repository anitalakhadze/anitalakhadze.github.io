FROM ubuntu:latest

ENV PYTHONUNBUFFERED=1
RUN apt update && \
    apt-get install -y nodejs npm git python3 build-essential ruby-full

SHELL [ "/bin/bash", "-c" ]

WORKDIR /code
RUN gem install jekyll sass bundler jekyll-minifier jekyll-sitemap

WORKDIR /code/app
COPY package.json .
RUN npm install
COPY . .
# ENTRYPOINT npm run start
CMD tail -f /dev/null
