FROM --platform=linux/amd64 python:3.9-slim

WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --force-reinstall -r requirements.txt

# Copy the app files
COPY . .

# Create the logging directory
RUN mkdir -p /var/log/app && \
    # non-root user
    adduser --disabled-password --gecos '' appuser && \
    # add user accesss to /app , logs folder
    chown -R appuser /app &&  chown -R appuser /var/log/app
# Switch to non-root user
USER appuser

# Expose port
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]
