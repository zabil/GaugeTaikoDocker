# Gauge Taiko Docker

This is sample gauge project illustrating gauge + taiko usage in a docker container

## Prerequisite

* docker

## Notes

* To run taiko inside a docker container the browser needs to be launched in headless mode unless you use `xvfb`
    Ex: `openBrowser({headless: true})`

    This project use a env to check if the headless should be true or not. Set `headless_chrome` env to true in `headless.properties` file or as a environment variable.

* To run taiko inside a docker container the browser needs to be launched with given args
    * --no-sandbox
    * --start-maximized
    * --disable-dev-shm-usage

    There are multiple ways to achieve this
        * Pass these args directly to the `openBrowser` API. Ex: `openBropwser({headles: true, args:["--no-sandbox","--start-maximized","--disable-dev-shm-usage"]})`;
        * Set `TAIKO_BROWSER_ARGS` env as required args list in the Dockerfile. ex: `ENV TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage`.
        * Set the `TAIKO_BROWSER_ARGS` env while running the dokcer command. `docker run -e TAIKO_BROWSER_ARGS=--no-sandbox,--start-maximized,--disable-dev-shm-usage -it IMAGE_NAME COMMAND`

## How to run

* Clone the repo

* Build image
    * Run `docker build . -t gauge-taiko`

* Run tests
    * Run `docker run -t gauge-taiko`

    or to run `gauge` args

    * Run `docker run --entrypoint="" -t gauge-taiko npx gauge {args for gauge command}`


* Viewing Reports / Logs

    * By default docker streams the stdout/stderr back to the host. So you get the console report without having to anything extra.

    * Mac/Windows

        * Run `docker run -v $(pwd)/gauge-reports:/gauge/reports -t gauge-taiko ` and then you can see the report in your host machine at `$(pwd)/gauge-reports` dir.

    * Linux
        * In Linux, viewing files generated in the container is not trivial. Since the Dockerfile uses a non-privileged users, mounting host volume
    does not work. (see https://github.com/moby/moby/issues/2259). As a workaround,
        * `docker create --name=gauge-taiko-test -t gauge-taiko` - Create a container
        * `docker start -a gauge-taiko-test` - Run the test
        * `docker cp gauge-taiko-test:/gauge/reports/ <DEST_PATH>` - copy the reports into the host
        * `docker rm gauge-taiko-test` Clean up
