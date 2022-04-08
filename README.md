NPI (Nginx Proxy Index)
=======================

NPI, Nginx Proxy Index, is a docker container that can generate an index page
for [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy), that lists the
running services (virtual hosts) to act as a kind of service index-page;
service discovery for humans.

Usage
-----

Use the included `docker-compose.yml` file, or run:

```console
docker run -d -v /var/run/docker.sock:/tmp/docker.sock -e INDEX_HOST="MyServer" -e VIRTUAL_HOST=index.local perbohlin/nginx-proxy-index
```

The variable INDEX_HOST is used to set the property `host` for the services listed
in the data file. If not set, empty string is used.

The docker compose example `docker-compose.yml`, assumes that the NPI is run
together and behind an `nginx-proxy`instance. Adjust image tag to `latest`
if running of latest official image instead of locally built test image.
Also, the variable `VIRTUAL_HOST` need to be changed to match the deployment
context.

Container Meta Data
-------------------

The following environmental variables can be set on containers in the network to
influence how they are rendered.

INDEX_NAME
: The service's link's text and title. The service's name defaults to the container name if not set.

INDEX_DESC
: The service's description.

INDEX_EXCLUDES
: Comma separated list of any virtual-host names that should not be listed in the index.
  This can be useful in case of multi-hostname services where only the primary should be listed.
  It can also be used to exclude the index-service itself from the list.

INDEX_GROUP
: The service-group the site belongs to.

INDEX_TAGS
: Comma separated list of string tags. It is a convenient way to allow multi-grouping
  of services beyond the group property.

Frontend Application
--------------------

The frontend web-application is [index-web](https://github.com/ZenDevelopmentEcosystem/index-web).

The `INDEX_WEB_CONFIG` environmental variable can be used to set the configuration.

The `config.json` file can also be overridden by mounting a file to:
`/usr/share/nginx/config/config.json`.

Implementation
--------------

The NPI service uses [docker-gen](https://github.com/nginx-proxy/docker-gen) to
generate the service-list in the form of a JSON-file. The location of the file
is set by the container environmental variable `INDEX_DATA_FILE` and defaults
`/usr/share/nginx/html/data/index.json`, where the frontend expects to find it.

The JSON file has the following format:

```json
{
    "sites": [
        {
            "name": "The name of the service",
            "description": "The text description of the service",
            "url": "The URL to the service",
            "group": "The service group the site belongs to",
            "host": "The name of the server/host where the container is running",
            "tags": ["List", "of" "strings"]

        }
    ]
}
```

The container uses [forego](https://github.com/nginx-proxy/forego/) as process runner.

Development
-----------

Run `make help` to learn more about the build-system.

Prior to pull-requests, run: `make check`

To build the image using a local filesystem version of the index-web application, create
a file `.env` based on the `env.template` file and set the appropriate variables
as described in the template file. By default, it will use the public repository.

To bring up a test-instance, run `make up`. In addition to the included `docker-compose.yml`
the mechanism allow for customization using your own file `local-docker-compose.yml`.

Acknowledgements
-----------------

The implementation is based on the [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy).
