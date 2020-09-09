FROM node:12.18.3-buster-slim@sha256:dd6aa3ed10af4374b88f8a6624aeee7522772bb08e8dd5e917ff729d1d3c3a4f
# Since Gauge and Taiko have first class npm support. This project can be run on a basic node image..

RUN apt-get update \
     && apt-get install -y wget gnupg ca-certificates \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y google-chrome-stable \
     && npm install -g @getgauge/cli@1.1.1 --unsafe-perm

# The Taiko installation downloads and installs the chromium required to run the tests. 
# However, we need the chromium dependencies installed in the environment. 
# These days, most Dockerfiles just install chrome to get the dependencies.

ENV TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage
ENV NPM_CONFIG_PREFIX=/home/gaugeuser/.npm-global
ENV headless_chrome=true

ADD . /gauge
WORKDIR /gauge

RUN groupadd -r gaugeuser && useradd -r -g gaugeuser -G audio,video gaugeuser && \
   mkdir -p /home/gaugeuser && \
   chown -R gaugeuser:gaugeuser /home/gaugeuser /gauge

USER gaugeuser
RUN npm install && gauge install

ENTRYPOINT ["npm", "test"]