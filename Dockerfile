FROM python:3.12-slim

# Set working directory to //home/mht-retail-dbt
WORKDIR /home/mht-retail-dbt

# Install system dependencies
RUN apt-get update && apt-get install -y git build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your source code into /home/mht-retail-dbt
COPY . .

# Copy profiles.yml into /dbt
COPY profiles.yml /dbt/profiles.yml

# Set environment variable for profiles directory
ENV DBT_PROFILES_DIR=/dbt

# Setup entrypoint script
RUN echo '#!/bin/bash\n\
echo "Starting dbt container..."\n\
echo "Available commands: dbt run, dbt test, dbt docs generate"\n\
exec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]