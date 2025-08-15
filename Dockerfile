# Use the official Python 3.9 image with Alpine Linux 3.13 as the base image.
FROM python:3.9-alpine3.13
# Add a label to specify the maintainer of the Dockerfile.
LABEL maintainer="alexpuhl.com"

# Set an environment variable to prevent Python from buffering its output.
ENV PYTHONUNBUFFERED=1

# Copy the requirements.txt file from the host to a temporary location in the container.
COPY ./requirements.txt /tmp/requirements.txt
# Copy the application code from the host to the /app directory inside the container.
COPY ./app /app
# Copy the development requirements file to a temporary location in the container.
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Set the working directory for all subsequent commands to /app.
WORKDIR /app
# Expose port 8000 to the outside world, allowing network traffic to the container.
EXPOSE 8000

# Define a build-time argument named DEV with a default value of 'false'.
ARG DEV=false
# This RUN instruction is a long command that executes multiple tasks.
RUN python -m venv /py && \
# Create a Python virtual environment at the /py directory.
    /py/bin/pip install --upgrade pip && \
# Upgrade the pip installer within the virtual environment.
    apk add --update --no-cache postgresql-client && \
# Install the PostgreSQL client libraries using the Alpine package manager (apk).
    apk add --update --no-cache --virtual .tmp-build-deps \
# Install temporary build dependencies (like compilers and libraries) required to compile some Python packages.
        build-base postgresql-dev musl-dev && \
# List the temporary build dependencies.
    /py/bin/pip install -r /tmp/requirements.txt && \
# Install the main application dependencies from requirements.txt.
    if [ $DEV = "true" ]; \
# Start of a conditional block: if the DEV argument is 'true'...
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
# ...then install the development dependencies from requirements.dev.txt.
    fi && \
# End of the conditional block.
    rm -rf /tmp && \
# Remove the temporary directory and its contents to reduce the final image size.
    apk del .tmp-build-deps && \
# Remove the temporary build dependencies, cleaning up the image.
    adduser \
# Create a new non-root user named django-user for security.
        --disabled-password \
# Disable password authentication for the new user.
        --no-create-home \
# Do not create a home directory for the new user.
        django-user
# Specify the name of the user to be created.

# Add the virtual environment's bin directory to the system's PATH.
ENV PATH="/py/bin:$PATH"

# Switch to the 'django-user' for subsequent commands and the container's runtime.
USER django-user
