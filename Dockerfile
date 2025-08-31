FROM python:3.9-alpine3.13
LABEL maintainer="Healer003"

ENV PYTHONBUFFERED 1

# What this 1st lines will tell that copy the requirements from the requirements.txt from a local machine to docker image
#2nd we are coping the app directory and ask the directory thats gonna contain our django app
COPY ./requirements.txt /temp/requirements.txt
COPY ./requirements.dev.txt /temp/requirements.dev.txt
COPY ./app /app
WORKDIR /app 
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /temp/requirements.txt && \
    if [ $DEV="true"]; \
        then /py/bin/pip install -r /temp/requirements.dev.txt ; \
    fi && \
    rm -rf /temp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH = "/py/bin:$PATH"

USER django-user