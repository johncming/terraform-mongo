variable "ip" {
  type = "string"
}

variable "mongo_port" {
  default = 27017
}

variable "web_port" {
  default = 8081
}

provider "docker" {
  host = "tcp://${var.ip}:2376"
}

resource "docker_image" "mongo" {
  name = "mongo:3.4.4"
}

resource "docker_image" "mongo-express" {
  name = "mongo-express:0.38.0"
}

resource "docker_container" "mongo" {

  name  = "mongo"
  image = "${docker_image.mongo.latest}"

  ports {
    internal = 27017
    external  = "${var.mongo_port}"
  }

  volumes {
    container_path = "/data/db"
    volume_name = "${docker_volume.shared_volume.name}"
  }
}

resource "docker_volume" "shared_volume" {
  name = "mongo"
}

resource "docker_container" "mongo-web" {
  name  = "mongo-web"
  image = "${docker_image.mongo-express.latest}"

  ports {
    internal = 8081
    external = "${var.web_port}"
  }

  links = ["mongo"]

}
