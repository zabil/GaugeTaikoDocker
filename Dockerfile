# This image uses the official node base image.
FROM node:12.18.3-buster-slim@sha256:dd6aa3ed10af4374b88f8a6624aeee7522772bb08e8dd5e917ff729d1d3c3a4f
 
# The Taiko installation downloads and installs the chromium required to run the tests. 
# However, we need the chromium dependencies installed in the environment. These days, most # Dockerfiles just install chrome to get the dependencies.
RUN apt-get update \
     && apt-get install -y wget gnupg ca-certificates \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y google-chrome-stable
 
# Set a custom npm install location so that Gauge, Taiko and dependencies can be 
# installed without root privileges
ENV NPM_CONFIG_PREFIX=/home/gauge/.npm-packages
ENV PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"

# Add the Taiko browser arguments
ENV TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage
ENV headless_chrome=true
ENV TAIKO_SKIP_DOCUMENTATION=true
#ENV TAIKO_SKIP_CHROMIUM_DOWNLOAD=true
#ENV TAIKO_BROWSER_PATH=/usr/bin/google-chrome
 
# Add test code
ADD . /gauge

# Set working directory
WORKDIR /gauge
 
# Copy the local working folder
COPY . .

# Create an unprivileged user to run Taiko tests
RUN groupadd -r gauge && useradd -r -g gauge -G audio,video gauge && \
   mkdir -p /home/gauge && \
   chown -R gauge:gauge /home/gauge /gauge
 
USER gauge

# Install dependencies and plugins
RUN npm install -g @getgauge/cli \
    && npm install \
    && gauge install \
    && gauge install screenshot \
    && gauge config check_updates false

# Default command on running the image
ENTRYPOINT ["npm", "test"]

