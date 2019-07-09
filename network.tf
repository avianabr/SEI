/* Network */


############################################
# Local variables
############################################

locals {
  tcp_protocol = "6"
  all_protocol = "all"
  anywhere     = "0.0.0.0/0"
}

############################################
# Create VCN
############################################

resource "oci_core_virtual_network" "vcn1" {
  display_name   = "vnc1"
  cidr_block     = "${var.vcn_cidr}"
  compartment_id = "${var.compartment_ocid}"
  dns_label      = "vnc1"
}

############################################
# Create Internet Gateway
############################################

resource "oci_core_internet_gateway" "igw1" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "igw1"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
}

############################################
# Create NAT Gateway
############################################

resource "oci_core_nat_gateway" "ngw1" {
  #Required
  compartment_id = "${var.compartment_ocid}"
  display_name   = "ngw1"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
}

############################################
# Create Service Gateway
############################################

resource "oci_core_service_gateway" "sgw1" {
  #Required
  compartment_id = "${var.compartment_ocid}"
  display_name   = "sgw1"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"

  services {
    #Required
    service_id = "${data.oci_core_services.list_of_services.services.0.id}"
  }

}

############################################
# Create Route Table
############################################

resource "oci_core_route_table" "public" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
  display_name   = "public"

  route_rules {
    destination       = "${local.anywhere}"
    network_entity_id = "${oci_core_internet_gateway.igw1.id}"
  }
}

resource "oci_core_route_table" "private" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
  display_name   = "private"

  route_rules {
    destination       = "${local.anywhere}"
    network_entity_id = "${oci_core_nat_gateway.ngw1.id}"
  }

  route_rules {
    destination       = "${data.oci_core_services.list_of_services.services.0.cidr_block}"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = "${oci_core_service_gateway.sgw1.id}"
  }

}

resource "oci_core_route_table" "admin" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
  display_name   = "admin"

  route_rules {
    destination       = "${local.anywhere}"
    network_entity_id = "${oci_core_internet_gateway.igw1.id}"
  }
}

############################################
# Create Security List
############################################

resource "oci_core_security_list" "public" {
  #Required
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
  display_name   = "public"

  egress_security_rules {
    #Required
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    #Required
    protocol = "6"
    source   = "0.0.0.0/0"


    tcp_options {

      #Optional
      max = "80"
      min = "80"

    }
  }

  ingress_security_rules {
    #Required
    protocol = "6"
    source   = "0.0.0.0/0"


    tcp_options {

      #Optional
      max = "443"
      min = "443"

    }
  }

  ingress_security_rules {
    #Required
    protocol = "6"
    source   = "${var.admin_subnet_cidr}"


    tcp_options {

      #Optional
      max = "22"
      min = "22"

    }
  }

}

resource "oci_core_security_list" "admin" {
  #Required
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
  display_name   = "admin"

  egress_security_rules {
    #Required
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    #Required
    protocol = "6"
    source   = "0.0.0.0/0"


    tcp_options {

      #Optional
      max = "22"
      min = "22"

    }
  }
}


resource "oci_core_security_list" "private" {
  #Required
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn1.id}"
  display_name   = "private"

  egress_security_rules {
    #Required
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  egress_security_rules {

    destination      = "${data.oci_core_services.list_of_services.services.0.cidr_block}"
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"

    tcp_options {

      #Optional
      max = "80"
      min = "80"

    }
  }

  egress_security_rules {

    destination      = "${data.oci_core_services.list_of_services.services.0.cidr_block}"
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"

    tcp_options {

      #Optional
      max = "443"
      min = "443"

    }
  }

  ingress_security_rules {
    #Required
    protocol = "6"
    source   = "${var.public_subnet_cidr}"


    tcp_options {

      #Optional
      max = "1521"
      min = "1521"

    }
  }

  ingress_security_rules {
    #Required
    protocol = "6"
    source   = "${var.public_subnet_cidr}"


    tcp_options {

      #Optional
      max = "8080"
      min = "8080"

    }
  }

  ingress_security_rules {
    #Required
    protocol = "6"
    source   = "${var.admin_subnet_cidr}"


    tcp_options {

      #Optional
      max = "22"
      min = "22"

    }
  }
}



############################################
# Create Public Subnets
############################################


resource "oci_core_subnet" "admin" {
  display_name      = "admin"
  cidr_block        = "${var.admin_subnet_cidr}"
  dns_label         = "admin"
  security_list_ids = ["${oci_core_security_list.admin.id}"]
  compartment_id    = "${var.compartment_ocid}"
  vcn_id            = "${oci_core_virtual_network.vcn1.id}"
  route_table_id    = "${oci_core_route_table.admin.id}"
  dhcp_options_id   = "${oci_core_virtual_network.vcn1.default_dhcp_options_id}"
}

resource "oci_core_subnet" "public" {
  display_name      = "public"
  cidr_block        = "${var.public_subnet_cidr}"
  dns_label         = "public"
  security_list_ids = ["${oci_core_security_list.public.id}"]
  compartment_id    = "${var.compartment_ocid}"
  vcn_id            = "${oci_core_virtual_network.vcn1.id}"
  route_table_id    = "${oci_core_route_table.public.id}"
  dhcp_options_id   = "${oci_core_virtual_network.vcn1.default_dhcp_options_id}"
}

resource "oci_core_subnet" "private" {
  display_name      = "private"
  cidr_block        = "${var.private_subnet_cidr}"
  dns_label         = "private"
  security_list_ids = ["${oci_core_security_list.private.id}"]
  compartment_id    = "${var.compartment_ocid}"
  vcn_id            = "${oci_core_virtual_network.vcn1.id}"
  route_table_id    = "${oci_core_route_table.private.id}"
  dhcp_options_id   = "${oci_core_virtual_network.vcn1.default_dhcp_options_id}"
}
