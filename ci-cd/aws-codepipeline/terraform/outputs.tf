output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.pipeline.name
}

output "pipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.pipeline.arn
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.build.name
}

output "artifact_bucket_name" {
  description = "Name of the S3 artifacts bucket"
  value       = aws_s3_bucket.pipeline_artifacts.bucket
}

output "pipeline_url" {
  description = "URL to the CodePipeline in AWS Console"
  value       = "https://console.aws.amazon.com/codesuite/codepipeline/pipelines/${aws_codepipeline.pipeline.name}/view"
}

