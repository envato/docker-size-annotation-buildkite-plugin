#!/usr/bin/env bats

setup() {
  load "$BATS_PLUGIN_PATH/load.bash"

  # Uncomment the following line to debug stub failures
  # export DOCKER_STUB_DEBUG=/dev/tty
  # export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty
}

@test "Annotates a single build" {
  export BUILDKITE_LABEL="My Label"
  export BUILDKITE_JOB_ID=0123456789abcedf
  export BUILDKITE_PLUGIN_DOCKER_SIZE_ANNOTATION_IMAGES="my-service"

  stub docker \
    "images --format \"**${BUILDKITE_LABEL}** - *my-service* docker image is **{{.Size}}** (Tag {{.Tag}} ID {{.ID}})\" \"buildkite0123456789abcedf-my-service\" : echo 5MB"

  stub buildkite-agent \
    "annotate --style info --context \"image_size_buildkite0123456789abcedf-my-service\" : exit 0"

  run "$PWD/hooks/post-command"

  assert_success

  unstub docker
  unstub buildkite-agent
}

@test "Annotates a single build (via array)" {
  export BUILDKITE_LABEL="My Label"
  export BUILDKITE_JOB_ID=0123456789abcedf
  export BUILDKITE_PLUGIN_DOCKER_SIZE_ANNOTATION_IMAGES_0="my-service"

  stub docker \
    "images --format \"**${BUILDKITE_LABEL}** - *my-service* docker image is **{{.Size}}** (Tag {{.Tag}} ID {{.ID}})\" \"buildkite0123456789abcedf-my-service\" : echo 5MB"

  stub buildkite-agent \
    "annotate --style info --context \"image_size_buildkite0123456789abcedf-my-service\" : exit 0"

  run "$PWD/hooks/post-command"

  assert_success

  unstub docker
  unstub buildkite-agent
}

@test "Annotates a many build" {
  export BUILDKITE_LABEL="My Label"
  export BUILDKITE_JOB_ID=0123456789abcedf
  export BUILDKITE_PLUGIN_DOCKER_SIZE_ANNOTATION_IMAGES_0="my-service"
  export BUILDKITE_PLUGIN_DOCKER_SIZE_ANNOTATION_IMAGES_1="my-service2"

  stub docker \
    "images --format \"**${BUILDKITE_LABEL}** - *my-service* docker image is **{{.Size}}** (Tag {{.Tag}} ID {{.ID}})\" \"buildkite0123456789abcedf-my-service\" : echo 5MB" \
    "images --format \"**${BUILDKITE_LABEL}** - *my-service2* docker image is **{{.Size}}** (Tag {{.Tag}} ID {{.ID}})\" \"buildkite0123456789abcedf-my-service2\" : echo 10MB"

  stub buildkite-agent \
    "annotate --style info --context \"image_size_buildkite0123456789abcedf-my-service\" : exit 0" \
    "annotate --style info --context \"image_size_buildkite0123456789abcedf-my-service2\" : exit 0"

  run "$PWD/hooks/post-command"

  assert_success

  unstub docker
  unstub buildkite-agent
}
