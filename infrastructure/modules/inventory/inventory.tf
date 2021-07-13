 resource "local_file" "ansible_inventory_read_secret" {
  content = templatefile("modules/inventory/inventory.tmpl",
    {
     config = var.s3_read_only
    }
  )
  filename = "inventory_r.yaml"
}

resource "local_file" "ansible_inventory_rw_secret" {
  content = templatefile("modules/inventory/inventory.tmpl",
    {
     config = var.s3_read_write
    }
  )
  filename = "inventory_rw.yaml"
}