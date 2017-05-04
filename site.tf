variable "db_path" {
  type = "string"
  default = "./db"
}

provider "docker" {
  host = "tcp://192.168.99.101:2376"
}

resource "docker_image" "mongo" {
  name = "mongo:latest"
}

resource "docker_image" "mongo-express" {
  name = "mongo-express:latest"
}

resource "docker_container" "mongo" {

  name  = "mongo"
  image = "${docker_image.mongo.latest}"

  ports {
    internal = 27017
    external  = 27017
  }

  volumes {
    from_container = "/data/db"
    host_path = "${var.db_path}"
  }
}

resource "docker_container" "mongo-web" {
  name  = "mongo-web"
  image = "${docker_image.mongo-express.latest}"

  ports {
    internal = 8081
    external = 8081
  }

  links = "mongo"
}
