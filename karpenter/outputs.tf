################################################################################
# Karpenter controller IAM Role
################################################################################

output "karpenter_iam_role_name" {
  description = "The name of the controller IAM role"
  value       = module.karpenter.iam_role_name
}

output "karpenter_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the controller IAM role"
  value       = module.karpenter.iam_role_arn
}

output "karpenter_iam_role_unique_id" {
  description = "Stable and unique string identifying the controller IAM role"
  value       = module.karpenter.iam_role_unique_id
}

################################################################################
# Node Termination Queue
################################################################################

output "karpenter_queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.karpenter.queue_arn
}

output "karpenter_queue_name" {
  description = "The name of the created Amazon SQS queue"
  value       = module.karpenter.queue_name
}

output "karpenter_queue_url" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.karpenter.queue_url
}

################################################################################
# Node Termination Event Rules
################################################################################

output "karpenter_event_rules" {
  description = "Map of the event rules created and their attributes"
  value       = module.karpenter.event_rules
}

################################################################################
# Node IAM Role
################################################################################

output "karpenter_node_iam_role_name" {
  description = "The name of the IAM role"
  value       = module.karpenter.node_iam_role_name
}

output "karpenter_node_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.karpenter.node_iam_role_arn
}

output "karpenter_node_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.karpenter.node_iam_role_unique_id
}

################################################################################
# Node IAM Instance Profile
################################################################################

output "karpenter_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = module.karpenter.instance_profile_arn
}

output "karpenter_instance_profile_id" {
  description = "Instance profile's ID"
  value       = module.karpenter.instance_profile_id
}

output "karpenter_instance_profile_name" {
  description = "Name of the instance profile"
  value       = module.karpenter.instance_profile_name
}

output "karpenter_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = module.karpenter.instance_profile_unique
}
