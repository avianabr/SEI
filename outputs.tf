// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

# Output the private and public IPs of the instance


output "list_of_services" {
  value = ["${data.oci_core_services.list_of_services.services}"]
}

output "list_of_db_versions" {
  value = ["${data.oci_database_db_versions.list_of_db_versions.db_versions}"]
}
