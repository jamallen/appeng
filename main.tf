terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

//  credentials = file("gcpterraform.json")
  project = "serious-octagon-314208"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  count = var.instance_count
  name         = "terraform-instance${count.index}"
  machine_type = "f1-micro"
  tags = ["http-server","web","dev","small"]


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Hello from ${google_compute_instance.vm_instance.name} Terraform on Google Cloud!</h1></body></html>' | sudo tee /var/www/html/index.html"


  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
        nat_ip = google_compute_address.vm_static_ip[count.index].address
    }
  }
}
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-rule"
  network = google_compute_network.vpc_network.name
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
  priority    = 1000

}
resource "google_compute_address" "vm_static_ip" {
  count = var.instance_count
  name = "terraform-static-ip${count.index}"
}