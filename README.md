# Docker size annotation

Annotates the build with a docker image size.

Supports [docker-compose-buildkite-plugin](docker-compose-buildkite-plugin)

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - label: "Build My Service"
    plugins:
      - docker-compose#v5.9.0:
          build: my-service
      - envato/docker-size-annotation#v2.0.0:
          annotate: my-service
```

or

```yml
steps:
  - label: "Build My Services"
    plugins:
      - docker-compose#v5.9.0:
          build:
            - my-service
            - my-service2
      - envato/docker-size-annotation#v2.0.0:
          annotate:
            - my-service
            - my-service2
```

## Configuration

`annotate`

The name of a service(s) to annotate. Either a single service or multiple services can be provided as an array.

## Developing

To run the lint:

```shell
docker-compose run --rm lint
```

To run the tests:

```shell
docker-compose run --rm tests
```
