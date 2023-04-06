variable "region" {
  type    = string
  default = "ap-south-1"

}
variable "vpc_info" {
  type    = string
  default = "192.168.0.0/16"
}

variable "subnet_info" {
  type = object({
    names          = list(string)
    public_subnets = list(string)
    zones          = list(string)
  })
  default = {
    zones          = ["a", "b"]
    names          = ["db1", "db2", "apache", "nginx"]
    public_subnets = ["apache", "nginx"]
  }
}
variable "application_version" {
  type    = number
  default = 1
}