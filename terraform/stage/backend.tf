terraform {
  backend "gcs" {
    bucket  = "terraform-state-backet"
    prefix  = "terraform/state/stage"
  }
}

