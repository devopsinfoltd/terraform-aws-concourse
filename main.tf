#---------------------------------------------------------
# DEPLOYING CONCOURSE IN AWS
# Concourse is a great CI server that builds your stuff
# inside containers. It can be pretty difficult to set up 
# in a distributed way, and this template will help reduce
# that difficulty.
#---------------------------------------------------------
provider "aws" {
  region = "${var.region}"
}

# Backend state
terraform {
  backend "s3" {}
}

module "concourse_cluster" {
  source = "./modules/concourse_cluster"
  region = "${var.region}"

  # Common config
  cluster_name = "${var.cluster_name}"
  vpc_id       = "${var.conc_vpc_id}"
  subnet_id    = "${var.conc_subnet_id}"
  conc_image   = "${var.conc_image}"

  # SSH config
  conc_ssh_key_name     = "${var.conc_ssh_key_name}"
  conc_ssh_ingress_cidr = "${var.conc_ssh_ingress_cidr}"

  # DB configuration
  conc_db_ingress_cidr  = "${var.conc_db_ingress_cidr}"
  conc_db_instance_type = "${var.conc_db_instance_type}"
  conc_db_pw            = "${var.conc_db_pw}"

  # Web configuration
  conc_web_ingress_cidr  = "${var.conc_web_ingress_cidr}"
  conc_web_instance_type = "${var.conc_web_instance_type}"
  conc_web_count         = "${var.conc_web_count}"
  conc_web_cert_arn      = "${var.conc_web_cert_arn}"
  conc_fqdn              = "${var.conc_fqdn}"
  conc_web_keys_dir      = "${path.root}/keys/web/"

  # auth
  authentication_config     = "${var.authentication_config}"

  # Worker
  conc_worker_count         = "${var.conc_worker_count}"
  conc_worker_instance_type = "${var.conc_worker_instance_type}"
  conc_worker_keys_dir      = "${path.root}/keys/worker/"
  conc_worker_vol_size      = "${var.conc_worker_vol_size}"
}
