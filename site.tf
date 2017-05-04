variable "ip" {
  type = "string"
}

provider "docker" {
  host = "tcp://192.168.99.${var.ip}:2376"
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
    external  = 27017
  }

  volumes {
    container_path = "/data/db"
    volume_name = "${docker_volume.shared_volume.name}"
  }
}

resource "docker_volume" "shared_volume" {}

resource "docker_container" "mongo-web" {
  name  = "mongo-web"
  image = "${docker_image.mongo-express.latest}"

  ports {
    internal = 8081
    external = 8081
  }

  links = ["mongo"]

}
