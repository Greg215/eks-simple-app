## ACM
1. The AWS certificate was created before the EKS module. 
2. Certificate for domain: ***blabla.blabla***

## Create EKS cluster
0. The modules can be found in the folder: ***modules***
1. The terraform code under the folder: ***eks***
2. Use Terraform version: ***1.0.5***
3. The cluster has: ***1 vpc module, 1 subnets module(you can specific the AZ), 1 network_loadbalancer, 1 eks_cluster, 1 eks_cluster and 1 route53 module***
4. Must update the Domain information for Route53 records for other environment case.
5. Must update the backend for other environment case.
6. Must provide the ACM certificate if enable TLS on Loadbalancer for other domains.
7. The basic variables can be updated on the tfvars file
8. Run init to init the whole cluster: ***terraform init***
9. To apply it: ***terraform apply***
10. To destroy it: ***terraform destroy***
11. The network module like VPC and Subnets has been included in the EKS module.(can be separate also)

## Jump Host
0. ***Once the instance is fully up and running, you can run the kubectl command without any additional configs.***
1. The module can be found in the folder ***modules***
2. The terraform code under the folder: ***jump-host***
3. Use Terraform version: ***1.0.5***
4. It will create a security group which open to all on port 22.
5. It on the latest ***Ubuntu OS***. (using the data module to find the ami)
6. In the user data file, just for the POC/test purposes, the instance will install aws cli, helm, kubectl, update the kubeconfig file, update the aws credential etc.
7. The basic variables can be updated on the ***tfvars*** file
8. This module also call the previous EKS state file to get the vpc and subnets information. 
9. Run init to init the whole cluster: ***terraform init***
10. To apply it: ***terraform apply***
11. To destroy it: ***terraform destroy*** 
12. This module can only be applied after the EKS module. 
13. The pem file for his instance can be found in this folder. ***tr-eks.pem***
14. ***ssh -i tr-eks.pem ubuntu@ip***

## ECR
1. This is a really simple module so I didn't create an additional module for it, but should also create a module for the real work.
2. The terraform code under the folder: ***ecr***
3. Use Terraform version: ***1.0.5***
4. It will create the ECR repository along with a policy.
5. Run init to init the whole cluster: ***terraform init***
6. To apply it: ***terraform apply***
7. To destroy it: ***terraform destroy*** 

## Install Helm operator
1. The code under folder: ***helm-operator***
2. It will create a new namespace: ***helm***
3. It will create a deployment to apply: ***fluxcd helm-operator***
4. It will create the customresource, rbac relate resources
5. To apply the deployment run: ***kubectl apply -f helm-operator-deployment.yaml***
6. To apply the customresource run: ***kubectl apply -f helm-customresource.yaml***
6. To apply the rbac run: ***kubectl apply -f helm-rbac.yaml***

## Install Nginx Operator for Ingress
1. The code under folder: ***ingress-operator***
2. It will create a new namespace for ingress
3. It will deploy the ingress by using helm chart via ***fluxcd***
4. To apply it run: ***kubectl apply -f nginx-operator.yaml***

## Docker hello world
0. Dockerfile is under folder ***docker***
1. Using the official nginx image ***nginx:latest***
2. It will build a new image with the index.xml file
3. The demo image was build locally and push to ecr with tag: latest
4. Image: ***ecr-repo/simple-tr:latest***

## K8s deployment file
1. The deployment file is under folder ***k8s-deployment***
2. It has a deployment, a service and an ingress.
3. Ideally could use the helm chart for the deployment.
4. Once all deployed you can reach the url via: ***https://hello.bla.bla***

# Further more (production)
1. Enable HPA
2. Enable metrics
3. Install Prometheus for metrics scrap
4. Install Grafana for dashboard 
5. Install fluent bit or sth similar for pods logging
6. Example dashboard for the pods of the created EKS. ***https://grafana.bla.bla/d/1tHNnf4nz/eks-tr-greg-pod-metrics?orgId=1&refresh=10s***
7. For grafana login ***username: admin, pwd: grafana***
8。 The prometheus has been configed. (installation in below section)

## Install Prometheus and Grafana with helm chart (optional)
1. The values file can be found under folder: ***monitoring***
2. The helm chart for prometheus can be found: https://github.com/prometheus-community/helm-charts
3. To add the prometheus chart to the repo: ***helm repo add prometheus-community https://prometheus-community.github.io/helm-charts***
4. The full values file for prometheus can be found: https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/values.yaml
5. The helm chart for the grafana can be found: https://github.com/grafana/helm-charts
6. To add the grafana chart to the repo: ***helm repo add grafana https://grafana.github.io/helm-charts***
7. The full values for the grafana can be found: https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml
8. Create a new namespace for monitoring: ***kubectl create namespace monitoring***
9. To install prometheus: ***helm install -f prometheus-value.yaml greg-prometheus prometheus-community/prometheus -n monitoring***
10. To install grafana: ***helm install -f grafana-value.yaml greg-grafana grafana/grafana -n monitoring***
11. To upgrade: ***helm upgrade -f prometheus-value.yaml prometheus prometheus-community/prometheus -n monitoring***
12: To uninstall: ***helm uninstall prometheus prometheus-community/prometheus -n monitoring***
13. For grafana login ***username: admin, pwd: grafana***