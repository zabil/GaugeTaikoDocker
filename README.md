# Gauge Taiko Docker

This is sample gauge project illustrating gauge + taiko usage in a docker container

## Prerequisite

* docker

## Notes

* To run taiko inside a docker container the browser always needs to be launched in headless mode
    Ex: `openBrowser({headless: true})`

    This project use a env to check if the headless should be true or not. Set `headless_chrome` env to true in `headless.properties` file or as a environment variable.

* To run taiko inside a docker container the browser needs to be launched with given args
    * --no-sandbox
    * --start-maximized
    * --disable-dev-shm-usage

Now there are multiple ways to achieve this
    * Pass these args directly to the `openBrowser` API. Ex: `openBropwser({headles: true, args:["--no-sandbox","--start-maximized","--disable-dev-shm-usage"]})`;
    * Set `TAIKO_BROWSER_ARGS` env as required args list in the Dockerfile. ex: `export TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage`.
    * Set the `TAIKO_BROWSER_ARGS` env while running the dokcer command. `docker run -e TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage -it IMAGE_NAME COMMAND`

## How to run

* Clone the repo

* Build image
    * Run `docker build . -t gauge-taiko`

* Run tests
    * Run `docker run -e TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage -e headless_chrome=true -it gauge-taiko /bin/sh -c "npm install &&  npm test"`

    or to run `gauge` args

    * Run `docker run -e TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage -e headless_chrome=true -it gauge-taiko /bin/sh -c "npm install && npm run gauge -- {args for gauge command}"`

    If you need to see the reports

    * Run `docker run -v $(pwd)/gauge-reports:/gauge/reports -e TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage -e headless_chrome=true -it gauge-taiko /bin/sh -c "npm install &&  npm test"` and then you can see the report in your host machine at `$(pwd)/gauge-reports` dir.

