


resource "oci_database_db_system" "sei_dbs1" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[var.availability_domains - 3], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  database_edition    = "ENTERPRISE_EDITION_EXTREME_PERFORMANCE"
  db_home {
    #Required
    database {
      #Required
      admin_password = "AAbbCCdd_#123"
      db_name        = "db1"
      pdb_name       = "pdb1"

      db_backup_config {

        #Optional
        auto_backup_enabled     = "true"
        recovery_window_in_days = "7"
      }
    }
    display_name = "db1"
    db_version   = "${var.db_version}"
  }
  hostname                = "db1"
  shape                   = "${var.instance_shape}"
  ssh_public_keys         = ["${var.ssh_public_key}"]
  subnet_id               = "${oci_core_subnet.private.id}"
  node_count              = "1"
  data_storage_size_in_gb = "1024"
  display_name            = "sei_dbs1"

}
