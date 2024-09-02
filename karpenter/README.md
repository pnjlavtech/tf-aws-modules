Missing Service Linked Role
Unless your AWS account has already onboarded to EC2 Spot, you will need to create the service linked role to avoid ServiceLinkedRoleCreationNotPermitted.

AuthFailure.ServiceLinkedRoleCreationNotPermitted: The provided credentials do not have permission to create the service-linked role for EC2 Spot Instances
This can be resolved by creating the Service Linked Role.

```bash
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com
```

only needed one time per account 






