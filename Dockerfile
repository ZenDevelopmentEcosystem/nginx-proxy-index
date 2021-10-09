# setup build arguments for version of dependencies to use
ARG DOCKER_GEN_VERSION=0.7.7
ARG FOREGO_VERSION=v0.17.0
ARG INDEX_WEB_TYPE=git
ARG INDEX_WEB_SRC=https://github.com/ZenDevelopmentEcosystem/index-web

# Use a specific version of golang to build both binaries
FROM golang:1.16.7 as gobuilder


# Build docker-gen from scratch
FROM gobuilder as dockergen
ARG DOCKER_GEN_VERSION
RUN git clone https://github.com/jwilder/docker-gen \
   && cd /go/docker-gen \
   && git -c advice.detachedHead=false checkout $DOCKER_GEN_VERSION \
   && go mod download \
   && CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.buildVersion=${DOCKER_GEN_VERSION}" ./cmd/docker-gen \
   && go clean -cache \
   && mv docker-gen /usr/local/bin/ \
   && cd - \
   && rm -rf /go/docker-gen


# Build forego from scratch
FROM gobuilder as forego
ARG FOREGO_VERSION
RUN git clone https://github.com/nginx-proxy/forego/ \
   && cd /go/forego \
   && git -c advice.detachedHead=false checkout $FOREGO_VERSION \
   && go mod download \
   && CGO_ENABLED=0 GOOS=linux go build -o forego . \
   && go clean -cache \
   && mv forego /usr/local/bin/ \
   && cd - \
   && rm -rf /go/forego


# index-web using git
FROM gobuilder as frontend-git
ARG INDEX_WEB_SRC
RUN git clone "${INDEX_WEB_SRC}" \
   && cp -r /go/index-web/html / \
   && rm -rf /go/index-web


# index-web using filesystem
FROM gobuilder as frontend-filesystem
ARG INDEX_WEB_SRC
COPY ${INDEX_WEB_SRC}/html /html

# index-web disabled
FROM gobuilder as frontend-none
RUN mkdir /html

FROM frontend-${INDEX_WEB_TYPE} as frontend

# Build the final image
FROM nginx:1.21.3
LABEL maintainer="Per Böhlin <per.bohlin@devconsoft.se>"

# Configure Nginx and apply fix for very long server names
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
   && sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf \
   && sed -i 's/worker_connections  1024/worker_connections  10240/' /etc/nginx/nginx.conf

# Install Forego + docker-gen
COPY --from=forego --chown=root:root --chmod=500 /usr/local/bin/forego /usr/local/bin/forego
COPY --from=dockergen --chown=root:root --chmod=500 /usr/local/bin/docker-gen /usr/local/bin/docker-gen

# Add DOCKER_GEN_VERSION environment variable
# Because some external projects rely on it
ARG DOCKER_GEN_VERSION
ENV DOCKER_GEN_VERSION=${DOCKER_GEN_VERSION}

COPY app /app/
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock
ENV INDEX_DATA_FILE=${INDEX_DATA_FILE:-/usr/share/nginx/html/data/index.json}

RUN rm -rf /usr/share/nginx/html
COPY --from=frontend --chown=nginx:ngincx /html /usr/share/nginx/html

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
