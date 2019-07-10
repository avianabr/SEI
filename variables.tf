variable "region" {
  default = "us-ashburn-1"
}

variable "availability_domains" {
  default = "3"
}

variable "compartment_ocid" {
  default = "ocid1.compartment.oc1..aaaaaaaa2lme5zwf4xt5dvaq7iw4q4acrvdk6vxi26o3y4cyg22oqdsky2cq"
}

variable "vcn_cidr" {
  default = "192.168.0.0/16"
}

variable public_subnet_cidr {
  description = "public subnet cidr"
  default     = "192.168.0.0/18"
}

variable private_subnet_cidr {
  description = "private subnet cidr"
  default     = "192.168.64.0/18"
}

variable admin_subnet_cidr {
  description = "admin subnet cidr"
  default     = "192.168.128.0/18"
}

variable ssh_public_key {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwkdeW+YiujLXVXjyxQO+s9uAWmsdvmEbizcf0wZOjnb/ScM+kSzs9eJE6TNwg5zG7H3TWDjC0egItxWLh+sjMK9RlNFotoU487PFLfrJrmSdl5uj5hJapVNB1wR+plj1/mz1TtDsAL9ifvqAC4IhdMIlGmgSY4HE0bgcHHvGx3s7+usIfL/Fwu/I7t8o6YzL+Aj3CLT6beyrWTk2qJaKsuYrCZ6BTCIeiRghbJpPHOhxLtNFcHO7Ar0fzGZ8YJXE3iNOAYV1kL/nLPVEzi3mzzchLRQn1YPC9QsU8xouZ+MthKDn4gxnVu7Buxjw5ADMeVFRXPrNGkZZuQnkOanaf"
}

variable instance_image_ocid {
  default = "ocid1.image.oc1.iad.aaaaaaaay66pu7z27ltbx2uuatzgfywzixbp34wx7xoze52pk33psz47vlfa"
}

variable instance_shape {
  description = "The shape of the compute instance"
  default     = "VM.Standard2.1"
}

variable "db_version" {
  default = "12.1.0.2.190416"
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = "${var.compartment_ocid}"
}

data "oci_core_services" "list_of_services" {
}

data "oci_database_db_versions" "list_of_db_versions" {
  #Required
  compartment_id = "${var.compartment_ocid}"

}
