#
# Cookbook Name:: opsworks-utils-cookbook
# Recipe:: instance-tags
#
# Copyright (c) 2016 Cornell University, All Rights Reserved.

# Rquires IAM policy something like this:

# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "Stmt1464916254000",
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateTags",
#                 "ec2:DeleteTags",
#                 "ec2:DescribeTags"
#             ],
#             "Resource": [
#                 "*"
#             ]
#         }
#     ]
# }

node['instance-tags'].each do |tag|
  aws_resource_tag node['ec2']['instance_id'] do
    tags(tag['key'] => tag['value'])
    action :update
  end
end

# Tag instances with OpsWorks instance ID and stack ID

instance = search('aws_opsworks_instance', 'self:true').first
stack = search('aws_opsworks_stack').first

aws_resource_tag 'opsworks-tags' do
  tags ({ 'opsworks-instance-id' => instance['instance_id'],
          'opsworks-stack-id' => stack['stack_id'] })
  resource_id node['ec2']['instance_id']
end
