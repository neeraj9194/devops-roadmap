resource "local_file" "ansible_inventory_read_secret" {
  content = templatefile("modules/inventory/inventory.tmpl",
    {
      s3_read_only  = var.s3_read_only
      s3_read_write = var.s3_read_write
    }
  )
  filename = "../ansible/s3_keys.yaml"
}
