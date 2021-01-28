// JSON templates for ECS Task Definition
locals {
  monolith_service = templatefile(
    "${path.module}/task-definitions/monolith-service.json",
    {
      alb_dns_name         = module.alb.alb_dns_name
      mysfits_monolith_url = data.aws_ecr_repository.mysfits_monolith.repository_url
    }
  )
  like_service = templatefile(
    "${path.module}/task-definitions/like-service.json",
    {
      alb_dns_name     = module.alb.alb_dns_name
      mysfits_like_url = data.aws_ecr_repository.mysfits_like.repository_url
      mysfits_xray_url = data.aws_ecr_repository.mysfits_xray.repository_url
      chaos_mode       = var.like_chaos_mode
      loglevel         = var.like_loglevel
    }
  )
}
