variable "kube_config" {
  type        = string
  description = "Path to the kubeconfig file"
  default     = "~/.kube/config"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy the application"
  default     = "dev"
}
