# service_shuffler

A Terraform module that shuffles AWS ECS services using lambda during autoscaling events. 
It will spin up a lambda and all underlying resources so that when an autoscaling group scales up or down your defined service will automatically adjust to the required number - keeping a predetermained number of tasks running on each host. Useful for tasks like fluentd where you need to have it running on the host before launching other tasks that will require it! 
Shuffle your AWS ECS Services on scale up and down!

0.1.0 prereqs - must have service configured with a 1:1 host - will address in v1.0

## Usage

```hcl
module "container_service_shuffler" {
  source = "github.com/kgirthofer/service_shuffler?ref=0.1.0"

  cluster_name             = "test-cluster"
  service_name             = "fluentd"
  auto_scaling_group_name  = "testClusterASG"
  lambda_name              = "test-shuffler"
  region                   = "us-east-1"
}
```
you will also need to copy the python lambda code zip file into your base 

## Variables

- `cluster_name`  - ECS Cluster name that you want the service deployed on
- `autoscaling_group_name`  - Name of the ASG you want to monitor for scale events
- `lambda_name`  - What you want your lambda function to be 
- `region`  - region for everything 

## TODO 
- Limit some of the IAM permissions down i.e. sid 2 resouce *
- Create the service from scratch 
