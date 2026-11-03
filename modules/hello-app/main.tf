
variable "namespace" {
  type = string
}

variable "image_tag" {
  type    = string
  default = "v2"
}

variable "replicas" {
  type    = number
  default = 3
}

variable "port" {
  type = number
}

# Create Kubernetes Namespace
resource "kubernetes_namespace_v1" "env" {
  metadata {
    name = var.namespace
  }
}

# Create Deployment
resource "kubernetes_deployment_v1" "hello" {
  metadata {
    name      = "hello-app"
    namespace = kubernetes_namespace_v1.env.metadata[0].name

    labels = {
      app = "hello-app"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "hello-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-app"
        }
      }

      spec {
        container {
          name  = "hello-app"
          image = "shripada/hello-app:${var.image_tag}"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Create LoadBalancer Service
resource "kubernetes_service_v1" "hello" {
  metadata {
    name      = "hello-app"
    namespace = kubernetes_namespace_v1.env.metadata[0].name
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "hello-app"
    }

    port {
      port        = var.port
      target_port = 80
    }
  }
}

# Outputs
output "url" {
  value = "http://localhost:${var.port}"
}

output "namespace" {
  value = kubernetes_namespace_v1.env.metadata[0].name
}
