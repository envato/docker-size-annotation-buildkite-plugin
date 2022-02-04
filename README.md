# Annotation Image Size

Annotates the build with a docker image size

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - command: ls
    plugins:
      - envato/annotate-image-size-buildkite-plugin#v1.0.0:
          pattern: "*.md"
```

## Configuration

n/a

## Developing

To run the lint:

```shell
docker-compose run --rm lint
```
