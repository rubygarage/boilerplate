output "ecr_repositories" {
  value = {
    web_server = aws_ecr_repository.web_server
    app        = aws_ecr_repository.app
  }
}

output "aws_key_pair" {
  value = aws_key_pair.this
}

output "aws_cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.this
}

output "bucket_name" {
  value = aws_s3_bucket.assets.bucket
}
