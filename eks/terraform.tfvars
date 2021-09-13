name               = "greg-eks"
cidr_block         = "172.31.232.0/21" #from 232.0 ~~ 239.255,   2048 in total
key_name           = "tr-eks"
kubernetes_version = "1.19"
aws_region         = "eu-central-1"
image_id           = "ami-0553f51213a17a3a7"

# work group
instance_type = "t3.small"
min_size      = 3
max_size      = 6

# work group with spot instance
//instance_market_options = {
//  market_type = "spot"
//
//  spot_options = {
//    block_duration_minutes         = null
//    instance_interruption_behavior = "terminate"
//    max_price                      = null
//    spot_instance_type             = "one-time"
//    valid_until                    = null
//  }
//}
