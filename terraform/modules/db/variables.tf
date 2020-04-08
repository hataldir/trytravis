variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable project {
  description = "Project ID"
  default     = "infra-271003"

}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}