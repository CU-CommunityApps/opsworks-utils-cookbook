# This recipe switches the running instances to limited CPU consumption
# if it is a t2 or t3 instance type.

# This recipe is NOT RUN by hook-setup.

# NOTE: The instance role requires the following IAM policy
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": [
#                 "ec2:ModifyInstanceCreditSpecification",
#                 "ec2:DescribeInstanceCreditSpecifications"
#             ],
#             "Resource": [
#                 "*"
#             ],
#             "Effect": "Allow"
#         }
#     ]
# }

ruby_block 'switch-t2-t3-to-limited-cpu' do
  block do
    require 'aws-sdk-core'

    instance = search('aws_opsworks_instance', 'self:true').first
    instance_id = instance['ec2_instance_id']
    instance_type = instance['instance_type']

    Chef::Log.info("Instance type: #{instance_type}")
    return if !instance_type.start_with?('t2.') && !instance_type.start_with?('t3.')

    stack = search('aws_opsworks_stack').first
    stack_region = stack[:region]

    Chef::Log.info("Creating EC2 client in region #{stack_region}")
    client = Aws::EC2::Client.new(region: stack_region)

    response = client.modify_instance_credit_specification(
      dry_run: false,
      # client_token: "String",
      instance_credit_specifications: [ # required
        {
          instance_id: instance_id,
          cpu_credits: node['opsworks-utils']['cpu-limit'] # standard, unlimited
        }
      ]
    )

    Chef::Log.info("Response from modify_instance_credit_specification: #{response}")
    raise 'Failed to limit cpu credit specification.' if response['successful_instance_credit_specifications'].empty?
  end
  only_if { node['opsworks-utils']['set-cpu-limit'] }
  action :run
end
