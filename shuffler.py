from __future__ import print_function
import boto3
import os

region = os.environ['REGION']
asg_name = os.environ['ASG_NAME']
service_name = os.environ['SERVICE_NAME']
cluster_name = os.environ['CLUSTER_NAME']

ecs = boto3.client('ecs', region)
asg = boto3.client('autoscaling')

def lambda_handler(event, context):
    print('Getting the current ASG Desired Capacity')
    total = asg.describe_auto_scaling_groups(
        AutoScalingGroupNames=[
            asg_name
        ]
    )['AutoScalingGroups'][0]['DesiredCapacity']
    print('Desired Capacity: {}'.format(total))
    print('Adjsitng Service to Desired Capacity')
    response = ecs.update_service(
        cluster=cluster_name,
        service=service_name,
        desiredCount=total
    )
    return total
