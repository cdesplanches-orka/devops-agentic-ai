terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kube_config
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}
