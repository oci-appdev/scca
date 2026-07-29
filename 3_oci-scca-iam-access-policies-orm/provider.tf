provider "oci" {
  # OCI Resource Manager supplies provider authentication. This stack contains
  # no API keys, private keys, fingerprints, user OCIDs, or auth tokens.
  region = var.region
}
