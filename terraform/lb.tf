#terraform {
#  required_version = ">0.12.8"
#}

#provider "google" {
#  version = "2.15"
#  project = var.project
#  region = var.region
#}




# used to forward traffic to the correct load balancer for HTTP load balancing
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
 target = google_compute_target_http_proxy.target_http_proxy.self_link
 port_range = "80"
 name = "reddit-forwarding-rule"
}

# used by one or more global forwarding rule to route incoming HTTP requests to a URL map
resource "google_compute_target_http_proxy" "target_http_proxy" {
  url_map = google_compute_url_map.url_map.self_link
  name = "reddit-proxy"
}


# defines a group of virtual machines that will serve traffic for load balancing
resource "google_compute_backend_service" "backend_service" {
  name = "reddit-backend-service"
  port_name = "puma"
  protocol = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]
  backend {
    group = google_compute_instance_group.reddit-vm-group.self_link
    balancing_mode = "RATE"
    max_rate_per_instance = 100
  }
}

# creates a group of dissimilar virtual machine instances
resource "google_compute_instance_group" "reddit-vm-group" {
  name = "reddit-vm-group"
  description = "Web servers instance group"
  instances = [
    google_compute_instance.app.self_link
  ]
  named_port {
    name = "puma"
    port = "9292"
  }
}

# determine whether instances are responsive and able to do work
resource "google_compute_health_check" "healthcheck" {
  name = "reddit-healthcheck"
  timeout_sec = 1
  check_interval_sec = 1
  http_health_check {
    port = 9292
  }
}

# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "url_map" {
  name = "reddit-url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

# show external ip address of load balancer
output "load-balancer-ip-address" {
  value = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}
