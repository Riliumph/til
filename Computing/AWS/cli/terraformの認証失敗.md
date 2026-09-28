# terraform

## エラー文

```console
$ terraform plan

Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: No valid credential sources found
│ 
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on provider.tf line 23, in provider "aws":
│   23: provider "aws" {
│ 
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│ 
│ Error: failed to refresh cached credentials, no EC2 IMDS role found, operation error ec2imds: GetMetadata, request canceled, context deadline exceeded
│ 
```

terraformでの認証失敗のエラー

## 優先度

[Authentication and Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration)によると以下の優先度らしい。

1. Parameters in the provider configuration
1. Environment variables
1. Shared credentials files
1. Shared configuration files
1. Container credentials
1. Instance profile credentials and Region
