data "template_cloudinit_config" "jump_host_bootstrap" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      sudo apt update -y
      curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
      sudo apt-get install apt-transport-https --yes
      echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      sudo apt update
      sudo apt install helm -y
      sudo apt install awscli -y
      sudo apt-get install -y apt-transport-https ca-certificates curl
      sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
      echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt-get update
      sudo apt-get install -y kubectl
      echo "********** here finished user data ***********"
      EOF
  }
}