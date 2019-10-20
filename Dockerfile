# Start with the lates python image
FROM python:latest

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy your source file
# COPY . /usr/src/app
COPY ./index.html /usr/src/app

# Expose your internal port - do not do that as heroku does not support EXPOSE
#EXPOSE 7000

# Define command to run your app
# CMD is required to run on Heroku
# $PORT is set for you by Heroku
CMD python -m http.server $PORT

