# Python Script Executor with nsjail and Flask

This repository contains a Python Flask application that allows users to securely execute Python scripts inside a `nsjail` environment. This setup ensures that the executed scripts are isolated from the host system for security.

## Prerequisites

- Docker installed on your system
- Google Cloud SDK (if deploying to Google Cloud Platform)
- Git installed on your system

## Files Overview

- `Dockerfile`: Defines the Docker image for the application.
- `nsjail.cfg`: Configuration file for nsjail.
- `app.py`: Flask application for handling script execution.
- `requirements.txt`: Python dependencies for the Flask application.

## Steps to Deploy

### 1. Clone the Repository

```sh
git clone https://github.com/yourusername/python-script-executor.git
cd python-script-executor
```

### 2. Build the Docker Image
Build the Docker image using the provided Dockerfile.

```sh
docker build -t python-executor .
```

### 3. Run the Docker Container
Run the Docker container locally to test the application.

```sh
docker run --rm -p 8080:8080 python-executor
```

### 4. Test the API
Use curl or any API testing tool (like Postman) to test the /execute endpoint.

Example using curl:
```sh
curl -X POST http://localhost:8080/execute -H "Content-Type: application/json" -d '{
    "script": "def main():\n    return {\"message\": \"Hello, World!\"}"
}'
```


### 5. Deploy to Google Cloud Platform
#### 5.1. Authenticate with Google Cloud
   Ensure you have the Google Cloud SDK installed and authenticate with your account.

```sh
gcloud auth login
```
#### 5.2. Set Your Google Cloud Project
```sh
gcloud config set project YOUR_PROJECT_ID
```
#### 5.3. Push the Docker Image to Google Container Registry
Tag your Docker image for Google Container Registry.

```sh
docker tag python-executor gcr.io/YOUR_PROJECT_ID/python-executor:latest
```
Push the image to Google Container Registry.

```sh
docker push gcr.io/YOUR_PROJECT_ID/python-executor:latest
```

#### 5.4. Deploy to Google Cloud Run
Deploy the Docker image to Google Cloud Run.
    
```sh
gcloud run deploy python-executor --image gcr.io/YOUR_PROJECT_ID/python-executor:latest --platform managed --region us-central1 --allow-unauthenticated
```

### Contributing
Feel free to submit issues or pull requests for improvements.

### License
This project is licensed under the MIT License.


This `README.md` file provides a detailed guide for setting up, running, and deploying the Python script execution service using `nsjail` and Flask, including all necessary configurations and steps for deployment on Google Cloud Platform.