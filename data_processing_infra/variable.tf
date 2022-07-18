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