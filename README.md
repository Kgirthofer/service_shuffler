# service_shuffler

A Terraform module that shuffles AWS ECS services using lambda during autoscaling events. 
It will spin up a lambda and all underlying resources so that when an autoscaling group scales up or down your defined service will automatically adjust to the required number - keeping a predetermained number of tasks running on each host. Useful for tasks like fluentd where you need to have it running on the host before launching other tasks that will require it! 
Shuffle your AWS ECS Services on scale up and down!

## Usage

```hcl
module "container_service_cluster" {
  source = "https://github.com/kgirthofer/service_shuffler?ref=0.1.0"

  cluster_name            = "test-cluster"
  autoscaling_group_name  = "testClusterASG"
  lambda_name             = "test-shuffler"
  region                  = "us-east-1"
}
```

## Variables

- `cluster_name`  - ECS Cluster name
- `autoscaling_group_name`  - Name of the ASG you want to monitor for scale events
- `lambda_name`  - What you want your lambda function to be 
- `region`  - region for everything 
