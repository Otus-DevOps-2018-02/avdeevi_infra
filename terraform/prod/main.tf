provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source           = "../modules/app"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  google_zone      = "${var.google_zone}"
  app_disk_image   = "${var.app_disk_image}"
  env              = "${var.env}"
}

module "db" {
  source           = "../modules/db"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  google_zone      = "${var.google_zone}"
  db_disk_image    = "${var.db_disk_image}"
  env              = "${var.env}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["91.220.181.76/32"]
  env           = "${var.env}"
}
