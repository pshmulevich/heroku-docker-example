# Start with the lates python image(?)
FROM python:latest

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy your source file
#COPY . /usr/src/app
COPY ./index.html /usr/src/app

# Expose your internal port
EXPOSE 7000

# Define command to run your app
CMD python -m http.server 7000

