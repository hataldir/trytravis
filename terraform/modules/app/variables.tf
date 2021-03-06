variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable project {
  description = "Project ID"
  default     = "infra-271003"

}

variable private_key_path {
  description = "Path to the private key"
}

variable db_ip_address {
}
