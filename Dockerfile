FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for mysqlclient
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Run the generate_env script and start the app
CMD ["sh", "-c", "ENV_TYPE=docker python generate_env.py && python manage.py migrate && gunicorn Library_Management.wsgi:application --bind 0.0.0.0:8000"]
