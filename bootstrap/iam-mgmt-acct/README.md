

# Bootstrapping the AWS Management Account   

Create cross acccount management account roles with sts assume for the env account gha deploy roles.

So those roles can perform actions in the management account.

Eg creating DNS delegate records for subdomains.

## PreRequisites 
* Multiple AWS accounts
* Setup AWS config and credentials for the accounts


## Steps 


a. Set WORKING_ENV envvar
```bash
export WORKING_ENV=management
```

b. Set AWS profile
```bash
export AWS_PROFILE=$WORKING_ENV
```

c. use assume (granted) get keys for management account
```bash
assume management
```