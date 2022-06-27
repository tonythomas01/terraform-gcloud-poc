# Allowing patchlevel updates, multistage build
FROM python:3.10-slim-bullseye as build

# Optional, when you need to compile e.g. extensions in C
#RUN apt-get update
#RUN apt-get install -y --no-install-recommends \
#build-essential gcc

WORKDIR /usr/app
# Python Virtual Environment
RUN python -m venv /usr/app/venv
ENV PATH="/usr/app/venv/bin:$PATH"

# Dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt


## Second stage ##
FROM python:3.10-slim-bullseye

# Create minimum privilege user
RUN groupadd -g 900 python && \
    useradd -r -u 900 -g python python

RUN mkdir /usr/app && chown python:python /usr/app

WORKDIR /usr/app

COPY --chown=python:python --from=build /usr/app/venv ./venv
COPY --chown=python:python . .

# Drop privilege
USER 900

ENV PATH="/usr/app/venv/bin:$PATH"
CMD [ "python", "tornado_app.py" ]

