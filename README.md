# heroku-docker-example

## This project is broken down into two steps: 
### 1) Create Basic Docker Project
### 2) Deploy to Heroku

-------------------------------------------------------------------------------------------------------------------------------------

## Basic Docker Project

### 1. Creating Dockerfile

Create a basic Dockerfile:

```
# [The FROM instruction](https://docs.docker.com/engine/reference/builder/#from) initializes a new build stage and sets the Base Image for subsequent instructions 
# Start with the latest python image ------------Absolutely required
FROM python:latest
 
# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
 
# Copy your source file(s)
COPY ./index.html /usr/src/app
 
# Expose your internal port ----------------Required if it is a webserver
EXPOSE 7000
 
# Define command to run your app  ------------Absolutely required
CMD python -m http.server 7000
 ```
 
### 2. Building an image called `hellodockerimage` with tag `latest`
  1. `mkdir hellodocker`
  2. `cd hellodocker` 
  3. `<create your Dockerfile in this folder>` 
  4. `docker build -t hellodockerimage:latest .`
 
### 3. Run docker instance `hellodockerinstance` from `hellodockerimage`
  1. `docker run --rm -it --name hellodockerinstance -p 8070:7000 hellodockerimage`
  2. Open it in browser using url: `localhost:8070`
  
The `--rm` option indicates that the container will be deleted automatically after it is stopped. To run the container in "detached" mode, add `-d` option. Note that `-p` option tells Docker to map internal port 7000 to host port 8070. 

-----------------------------------------------------------------------------------------------------------------------
## Changes required to run in Heroku
Heroku does not support EXPOSE instruction to specify an internal port number. Instead it provides $PORT environmental variable for your application. Make the following Dockerfile changes to be able to run in Heroku:

### 1) Modify Dockerfile: 
```
# Start with the latest python image
FROM python:latest

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy your source file(s)
COPY ./index.html /usr/src/app

# Expose your internal port - do not do that as heroku does not support EXPOSE
# EXPOSE 7000

# Define command to run your app
# CMD is required to run on Heroku
# $PORT is set for you by Heroku
CMD python -m http.server $PORT
```
### 2) Build and test your updated project again
  1. `docker build -t hellodockerimage:latest .`
  2. `docker run -e PORT=7000 --rm -it --name hellodockerinstance -p 8070:7000 hellodockerimage`
  3. Open it in browser using url: `localhost:8070`

Note that the $PORT value is now passed to the container as an environmental variable using `-e` option.

-----------------------------------------------------------------------------------------------------------------------
## Deploy to Heroku

### Create a new Heroku application
* Login to [https://dashboard.heroku.com/apps](https://dashboard.heroku.com/apps)
* Click the New button and select Create New App
* Fill in the App name as <your-heroku-app-name> and click the Create app button.

### Install Heroku CLI (assuming Windows):
1. Download tar.gz file from [here](https://devcenter.heroku.com/articles/heroku-cli#other-installation-methods)
2. Open WinZIP or a similar program as administrator
3. Expand the contents of the tar.gz file to `C:\heroku` folder
4. Add `C:\heroku\bin` to Windows System PATH

### Login with Heroku CLI
```
# Log into Heroku, it will open a browser login page:
heroku login
# login to heroku container (Docker) registry:
heroku container:login 
# Go to the folder where your Dockerfile is located:
cd <docker-project-folder> 
```

### Set up the project
```
# Initialize project folder as git repo 
git init

# Set up Heroku git remote to point to your application
heroku git:remote -a <your-heroku-app-name> 

# Commit your files to Heroku git
git add . 
git commit -m "Initial Commit" 

# Push your container to docker registry as a web application (may take some time)
heroku container:push web
```

### Release your Heroku project
```
# This will publish your Docker Container as Heroku Application
heroku container:release web 
```
### How to test Heroku Project:
Go to the following url: <your-heroku-app-name>.herokuapp.com