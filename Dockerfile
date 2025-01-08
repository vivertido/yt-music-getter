# Use the official Python image from the Docker Hub
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install yt-dlp
RUN pip install yt-dlp

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Ensure .sh files have execute permission
RUN chmod +x /app/*.sh

# Run the shell script to set up the environment (if needed)
RUN /app/setup.sh

# Run app.py when the container launches
CMD ["python", "app.py"]