output "aws_iam_role_github_actions_arn" {
  description = "AWS IAM role for gihub actions to use for JWT (OIDC) ARN"
  value       = aws_iam_role.github_actions_deploy_role.arn
}
output "aws_iam_role_github_actions_name" {
  description = "AWS IAM role for gihub actions to use for JWT (OIDC) Name"
  value       = aws_iam_role.github_actions_deploy_role.name
}