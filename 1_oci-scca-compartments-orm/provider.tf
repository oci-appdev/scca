provider "oci" {
  # OCI Resource Manager supplies authentication to the provider. Do not place
  # API keys, fingerprints, private keys, or user OCIDs in this stack.
  region = var.region
}
