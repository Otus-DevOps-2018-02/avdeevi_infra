resource "google_compute_instance_group" "reddit-app-servers" {
  name        = "my-reddit-app-servers"
  description = "Группа апп-серверов для балансирования нагрузки"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "puma"
    port = "9292"
  }

  zone = "${var.google_zone}"
}

resource "google_compute_global_forwarding_rule" "my-app-forwarding-rule" {
  name       = "my-app-forwarding-rule"
  target     = "${google_compute_target_http_proxy.my-app-http-proxy.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "my-app-http-proxy" {
  name    = "my-app-http-proxy"
  url_map = "${google_compute_url_map.my-app-url-map.self_link}"
}

resource "google_compute_url_map" "my-app-url-map" {
  name            = "my-app-url-map"
  default_service = "${google_compute_backend_service.my-app-backend-service.self_link}"
}

resource "google_compute_backend_service" "my-app-backend-service" {
  name        = "my-app-backend"
  port_name   = "puma"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  health_checks = ["${google_compute_http_health_check.puma-check.self_link}"]

  backend {
    group = "${google_compute_instance_group.reddit-app-servers.self_link}"
  }
}

resource "google_compute_http_health_check" "puma-check" {
  name               = "puma-check"
  request_path       = "/"
  check_interval_sec = 5
  timeout_sec        = 5
  port               = "9292"
}

resource "google_compute_firewall" "firewall_load_balancer" {
  name    = "allow-from-load-balancer"
  network = "default"
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  target_tags   = ["reddit-app"]
#  source_ranges = ["0.0.0.0/0"]
}


