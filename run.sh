#!/bin/bash

# Build the Jekyll static webpages
# docker run --rm -v "$(pwd)":/srv/jekyll -it jekyll/jekyll:latest jekyll build

# Run the Jekyll server and connect it to port 8080
docker run --rm -p 4000:4000 -v "$(pwd)":/srv/jekyll -it jekyll/jekyll:latest jekyll serve --host 0.0.0.0
