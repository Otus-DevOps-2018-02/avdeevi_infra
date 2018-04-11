resource "google_compute_instance" "db" {
  count        = "${var.instance_count}"
  name         = "${var.env}-reddit-db-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.google_zone}"

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  tags = ["reddit-db","${var.env}"]

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

resource "google_compute_firewall" "firewall_mongo" {
  name    = "${var.env}-allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}

