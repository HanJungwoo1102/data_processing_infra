variable "pre_tag_name" {
    type = string
}

variable "ec2_key_pair" {
    type = string
}

variable "default_tags" {
    type = map(string)
}

variable "ec2_instance_config" {
    type = map(string)
}

variable "db_config" {
    type = map(string)
}

variable "availability_zone_1" {
    type = string
}

variable "availability_zone_2" {
    type = string
}

variable "subnet_cidr_blocks" {
    type = list(string)
}
