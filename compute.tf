resource "oci_core_instance" "bastion" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.availability_domains - 1], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "bastion1"
  shape               = "VM.Standard2.1"
  subnet_id           = "${oci_core_subnet.admin.id}"
  hostname_label      = "bation"

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid}"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }


}

resource "oci_core_instance" "sei" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.availability_domains - 2], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "sei"
  shape               = "VM.Standard2.1"
  subnet_id           = "${oci_core_subnet.public.id}"
  hostname_label      = "sei"

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid}"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }


}


resource "oci_core_instance" "sip" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.availability_domains - 3], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "sip"
  shape               = "VM.Standard2.1"
  subnet_id           = "${oci_core_subnet.public.id}"
  hostname_label      = "sip"

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid}"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }


}


resource "oci_core_instance" "solr" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.availability_domains - 1], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "solr"
  shape               = "VM.Standard2.2"
  subnet_id           = "${oci_core_subnet.private.id}"
  hostname_label      = "solr"

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid}"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }


}

resource "oci_core_instance" "jod" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.availability_domains - 2], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "jod"
  shape               = "VM.Standard2.2"
  subnet_id           = "${oci_core_subnet.private.id}"
  hostname_label      = "jod"

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid}"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }


}
