terraform {
  required_version = ">0.12.8"
}

provider "google" {
  version = "2.15"

  project = var.project

  region = var.region
}

# VM reddit-app
resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-b"
  tags = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
# Provisioners connection
  connection {
   type = "ssh"
   host = self.network_interface[0].access_config[0].nat_ip
   user = "appuser"
   agent = false
   private_key = file("~/.ssh/appuser")
  }
# Create service
  provisioner "file" {
   source = "files/puma.service"
   destination = "/tmp/puma.service"
  }

# Deploy app
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

}


# Firewall rules
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}
