## AWS ECS Workshop completed infrastructure

Based on the [AWS ECS workshop](https://github.com/spugachev/amazon-ecs-mythicalmysfits-workshop)
Rewrite CloudFormation core stack and provision scripts into Terraform

1) Used file-layout isolation (per services and per environment)
2) Used S3 remote backends isolation (per services and per system)
3) Used simple ALB module from example [repo](https://github.com/silazare/terraform-aws-example/tree/master/modules/alb)
4) Used static files S3 and DynamoDB data fast deployment with terraform (not production-ready solution)

Prerequisites:
* terraform >= 0.13
* amazon-ecr-credential-helper (for push images into ECR)
* tfsec >= v0.36.11 (for pre-commit usage)
* tflint >= 0.23.0 (for pre-commit usage)
* checkov >= 1.0.675 (for pre-commit usage)

Pre-commit installation:
```shell
git secrets --install
pre-commit install -f
pre-commit run -a
```

### Deploy Monolith application with Like Microservice (Strangler pattern)

1) Create buckets and DynamoDB table for Terraform remote backends (global/s3)

```shell
cd global/s3
make plan
make apply
```

2) Configure backend.config and terraform.tfvars with details in each Staging dir

3) Create Staging ECR (staging/ecr)

```shell
cd staging/ecr
make plan
make apply
```

4) Build Docker images and push it to ECR via script:
```
cd app
./build_images.sh <aws account id>
```

5) Create DynamoDB table with data (staging/dynamodb)

```shell
cd staging/dynamodb
make plan
make apply
```

6) Create Staging VPC (staging/vpc)

```shell
cd staging/vpc
make plan
make apply
```

7) Create Staging ECS cluster (staging/ecs) and check API ALB endpoint

```shell
cd staging/ecs
make plan
make apply
```

8) Upload FrontEnd (staging/s3web) and check S3 website URL

```shell
cd staging/s3web
make plan
make apply
```

9) Load testing example to check ECS Like service AutoScaling

```shell
ab -p data.json -c 20 -n 10000 <ALB FQDN>/mysfits/33e1fbd4-2fd8-45fb-a42f-f92551694506/like
```

10) Destroy Infrastructure in strict reverse order, otherwise tfstate dependenices will be broken
