resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"

  volume_binding_mode = "WaitForFirstConsumer"

  reclaim_policy = "Delete"

  parameters = {
    type      = "gp3"
    fsType    = "ext4"
    encrypted = "true"
  }
}