# Use a specific version of Alpine Linux
FROM alpine:3.14

# Install python, pip, and bash
RUN apk add --no-cache --update python3 py3-pip bash

# Add and install dependencies
ADD ./webapp/requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt --user

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Set the entry point to your shell script
ENTRYPOINT ["sh", "/usr/src/app/docker-entrypoint.sh"]

# Run the app. CMD is required to run on Heroku
# $PORT is set by Heroku
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "wsgi"]
