workflow "build & test" {
  on = "push"
  resolves = ["publish"]
}

action "build" {
  uses = "docker://docker"
  runs = ["sh", "-c", "docker build -t gcr.io/$GCP_PROJECT/$GITHUB_REPOSITORY:$GITHUB_SHA ."]
  secrets = ["GCP_PROJECT"]
}

action "auth gcr" {
  uses = "actions/gcloud/auth@master"
  secrets = ["GCR_AUTH"]
}

action "publish" {
  needs = ["auth google cloud", "build"]
  uses = "actions/gcloud/cli@master"
  runs = ["sh", "-c", "gcloud docker -- push gcr.io/$GCP_PROJECT/$GITHUB_REPOSITORY:$GITHUB_SHA"]
  secrets = ["GCP_PROJECT"]
}
