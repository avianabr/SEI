/*resource "oci_database_autonomous_database" "atp2" {
  #Required
  admin_password           = "AAbbCCdd_#123"
  compartment_id           = "${var.compartment_ocid}"
  cpu_core_count           = "1"
  data_storage_size_in_tbs = "1"
  db_name                  = "atp2"

  #Optional

  display_name = "atp2"

  whitelisted_ips = ["${var.vcn_cidr}]


}
*/
