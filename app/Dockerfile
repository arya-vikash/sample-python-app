# Base image with security in mind
FROM --platform=linux/amd64 python:3.9-slim

# Working directory
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN pip uninstall -y -r requirements.txt || true
RUN pip install --no-cache-dir --force-reinstall -r requirements.txt

# Copy the app files
COPY . .

# Expose port
EXPOSE 5000
# Create the logging directory
RUN mkdir -p /var/log/app 
# non-root user
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app &&  chown -R appuser /var/log/app
USER appuser



# Command to run the app
CMD ["python", "app.py"]
