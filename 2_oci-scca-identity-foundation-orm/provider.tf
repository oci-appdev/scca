provider "oci" {
  # OCI Resource Manager supplies provider authentication. Do not place API
  # keys, private keys, fingerprints, auth tokens, or user OCIDs in this stack.
  region = var.region
}
