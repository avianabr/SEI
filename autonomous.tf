resource "oci_database_autonomous_database" "sei_atp1" {
  #Required
  admin_password           = "AAbbCCdd_#123"
  compartment_id           = "${var.compartment_ocid}"
  cpu_core_count           = "1"
  data_storage_size_in_tbs = "1"
  db_name                  = "sei_atp1"

  #Optional

  display_name = "sei_atp1"

  whitelisted_ips = ["${var.public_subnet_cidr}]


}
