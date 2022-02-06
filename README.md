# Docker size annotation

Annotates the build with a docker image size.

Supports [docker-compose-buildkite-plugin](docker-compose-buildkite-plugin)

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - label: "Build My Service"
    plugins:
      - docker-compose#v3.8.0:
          build: my-service
      - envato/docker-size-annotation#v1.0.0: ~
```

## Configuration

n/a

## Developing

To run the lint:

```shell
docker-compose run --rm lint
```

To run the tests:

```shell
docker-compose run --rm tests
```
