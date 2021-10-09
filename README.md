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
docker run -d -v /var/run/docker.sock:/tmp/docker.sock -e VIRTUAL_HOST=index.local perbohlin/nginx-proxy-index
```

Container Meta Data
-------------------

The following environmental variables can be set on containers in the network to
influence how they are rendered.

INDEX_NAME
: The service's link's text and title. The service's name defaults to the container name if not set.

INDEX_DESC
: The service's description.

INDEX_EXCLUDES
: Comma separated lists of any virtual-host names that should not be listed in the index.
  This can be useful in case of multi-hostname services where only the primary should be listed.
  It can also be used to exclude the index-service itself from the list.

INDEX_GROUP
: The service-group the site belongs to. This property will be utilized in the visualization
  in the future. Currently only present in the index.json file.

Implementation
--------------

The NPI service uses [docker-gen](https://github.com/nginx-proxy/docker-gen) to
generate the service-list in the form of a JSON-file named `index.json` in the
servers web-root.

The JSON file has the following format:

```json
{
    "sites": [
        {
            "name": "The name of the service",
            "description": "The text description of the service",
            "url": "The URL to the service",
            "group": "The service group the site belongs to"
        }
    ]
}
```

The frontend is [index-web](https://github.com/ZenDevelopmentEcosystem/index-web).

The container uses [forego](https://github.com/nginx-proxy/forego/) as process runner.

Development
-----------

Run `make help` to learn more about the build-system.

Prior to pull-requests, run: `make check`

To build the image using a local filesystem version of the index-web application, create
a file `.env` based on the `env.template` file and set the appropriate variables
as described in the template file. By default, it will use the public repository.

Acknowledgements
-----------------

The implementation is based on the [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy).
