output "bucketname" {
  value = aws_s3_bucket.s3-static-portfolio.bucket
}

output "website" {
  value = aws_s3_bucket_website_configuration.s3-static-website.website_endpoint
}