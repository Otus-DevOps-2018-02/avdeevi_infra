resource "google_compute_instance" "app" {
  count        = "${var.instance_count}"
  name         = "${var.env}-reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.google_zone}"

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  tags = ["reddit-app", "${var.env}"]

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

}

resource "google_compute_firewall" "firewall_puma" {
  name    = "default-allow-puma-${var.env}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}

resource "google_compute_firewall" "firewall_http" {
  name    = "default-allow-http-${var.env}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip-${var.env}"
}
