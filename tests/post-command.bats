#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following line to debug stub failures
# export DOCKER_STUB_DEBUG=/dev/tty
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Annotates a single services" {
  export BUILDKITE_LABEL="My Label"
  export BUILDKITE_BUILD_NUMBER=1000
  FILE="docker-compose.buildkite-${BUILDKITE_BUILD_NUMBER}-override.yml"
  cat <<EOT > $FILE
version: '2.4'
services:
  my-service:
    image: XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/my-repo:project-my-service-build-1000
EOT

  stub docker \
    "images --format \"**${BUILDKITE_LABEL}** docker image is **{{.Size}}** (Tag {{.Tag}} ID {{.ID}})\" \"XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/my-repo:project-my-service-build-1000\" : echo 5MB"

  stub buildkite-agent \
    "annotate --style info --context \"project-my-service-build-1000-size\" : exit 0"

  run "$PWD/hooks/post-command"
  rm -f $FILE

  assert_success

  unstub docker
  unstub buildkite-agent
}


@test "Annotates many services" {
  export BUILDKITE_LABEL="My Label"
  export BUILDKITE_BUILD_NUMBER=2000
  FILE="docker-compose.buildkite-${BUILDKITE_BUILD_NUMBER}-override.yml"
  cat <<EOT > $FILE
version: '2.4'
services:
  my-service:
    image: XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/my-repo:project-my-service-build-2000
  my-service2:
    image: XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/my-repo:project-my-service2-build-2000
EOT

  stub docker \
    "images --format \"**My Label** docker image is **{{.Size}}** (Tag {{.Tag}} ID {{.ID}})\" \"XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/my-repo:project-my-service-build-2000\" : echo 5MB" \
    "images --format \"**My Label** docker image is **{{.Size}}** (Tag {{.Tag}} ID {{.ID}})\" \"XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/my-repo:project-my-service2-build-2000\" : echo 10MB"

  stub buildkite-agent \
    "annotate --style info --context \"project-my-service-build-2000-size\" : exit 0" \
    "annotate --style info --context \"project-my-service2-build-2000-size\" : exit 0"

  run "$PWD/hooks/post-command"
  rm -f $FILE

  assert_success

  unstub docker
  unstub buildkite-agent
}