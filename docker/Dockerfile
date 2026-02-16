# Dockerfile for LiteLLM Proxy
FROM python:3.12-slim

# Set workdir
WORKDIR /app


# Copy requirements from docker/requirements.txt
COPY docker/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy all source code
COPY .. .

# Expose the proxy port
EXPOSE 4000

# Default command to run the proxy
CMD ["python", "-m", "litellm"]