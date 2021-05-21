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
  tags = ["web","dev","small"]


  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
        nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}
resource "google_compute_address" "vm_static_ip" {
  count = var.instance_count
  name = "terraform-static-ip${count.index}"
}