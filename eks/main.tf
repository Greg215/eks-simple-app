# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE EKS-CLUSTER
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "eks_vpc" {
  source     = "../modules/vpc"
  name       = var.name
  cidr_block = var.cidr_block
}

module "eks_subnets" {
  source               = "../modules/subnet"
  name                 = var.name
  eks_cluster_name     = var.name
  vpc_id               = module.eks_vpc.vpc_id
  igw_id               = module.eks_vpc.igw_id
  nat_instance_enabled = false
}

# load balancer
module "network_loadbalancer" {
  source                         = "../modules/nlb"
  name                           = var.name
  vpc_id                         = module.eks_vpc.vpc_id
  vpc_public_subnet_ids          = module.eks_subnets.public_subnet_ids
  aws-load-balancer-ssl-cert-arn = var.aws-load-balancer-ssl-cert-arn

  listeners = [
    {
      port     = 80
      protocol = "TCP",
      target_groups = {
        port              = 30080
        proxy_protocol    = false
        health_check_port = "traffic-port"
      }
    },
    {
      port     = 443
      protocol = "TLS",
      target_groups = {
        port              = 30080
        proxy_protocol    = false
        health_check_port = "traffic-port"
      }
    },
  ]

  # below security group will need to be changed, once we know which port and ip.
  security_group_for_eks = [
    {
      port_from  = 0
      port_to    = 65535
      protocol   = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
  ]
}

module "eks_workers" {
  source                    = "../modules/eks-worker"
  name                      = module.eks_cluster.eks_cluster_id
  key_name                  = var.key_name
  image_id                  = var.image_id
  instance_type             = var.instance_type
  vpc_id                    = module.eks_vpc.vpc_id
  subnet_ids                = module.eks_subnets.private_subnet_ids
  health_check_type         = var.health_check_type
  min_size                  = var.min_size
  max_size                  = var.max_size
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  cluster_name                       = module.eks_cluster.eks_cluster_id
  cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
  cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data

  cluster_security_group_id              = var.cluster_security_group_id
  additional_security_group_ids          = [module.network_loadbalancer.security_group_k8s]
  cluster_security_group_ingress_enabled = var.cluster_security_group_ingress_enabled
  associate_public_ip_address            = var.associate_public_ip_address

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = true
  cpu_utilization_high_threshold_percent = var.cpu_utilization_high_threshold_percent
  cpu_utilization_low_threshold_percent  = var.cpu_utilization_low_threshold_percent

  target_group_arns = concat(module.network_loadbalancer.target_group_arns)
}

module "eks_cluster" {
  source     = "../modules/eks-cluster"
  name       = var.name
  vpc_id     = module.eks_vpc.vpc_id
  subnet_ids = module.eks_subnets.public_subnet_ids

  kubernetes_version    = var.kubernetes_version
  oidc_provider_enabled = false

  workers_role_arns          = [module.eks_workers.workers_role_arn]
  workers_security_group_ids = [module.eks_workers.security_group_id]
}

module "route53" {
  source  = "../modules/route53-records"
  zone_id = var.zone_id
  type    = "CNAME"

  records = [
    {
      NAME   = "*.${var.subdomian}"
      RECORD = module.network_loadbalancer.dns_name
      TTL    = "300"
    },
  ]
}