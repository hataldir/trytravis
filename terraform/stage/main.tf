provider "google" {
  version = "~>2.15"
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  #  project = var.project
  zone           = var.zone
  app_disk_image = var.app_disk_image
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  #  project = var.project
  zone          = var.zone
  db_disk_image = var.db_disk_image
}

module "vpc" {
  source = "../modules/vpc"
  #  project = var.project
  source_ranges = ["0.0.0.0/0"]
  #  source_ranges = ["85.235.46.178/32"]

}
