

#creating s3 bucket

resource "aws_s3_bucket" "s3-static-portfolio" {

  bucket = var.bucketname

}

#ownership of the static website bucket
resource "aws_s3_bucket_ownership_controls" "static-portfolio-owner" {
  bucket = aws_s3_bucket.s3-static-portfolio.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#creating s3 bucket public access
resource "aws_s3_bucket_public_access_block" "static-portfolio-access" {
  bucket = aws_s3_bucket.s3-static-portfolio.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#providing acl access
resource "aws_s3_bucket_acl" "s3-static-portfolio" {
  depends_on = [
    aws_s3_bucket_ownership_controls.static-portfolio-owner,
    aws_s3_bucket_public_access_block.static-portfolio-access,
  ]

  bucket = aws_s3_bucket.s3-static-portfolio.id
  acl    = "public-read"
}

#uploading files to s3 bucket
resource "aws_s3_object" "s3-static-index-file" {
  bucket       = aws_s3_bucket.s3-static-portfolio.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}
resource "aws_s3_object" "s3-static-error-file" {
  bucket       = aws_s3_bucket.s3-static-portfolio.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}
resource "aws_s3_object" "s3-static-profilephotto-file" {
  bucket       = aws_s3_bucket.s3-static-portfolio.id
  key          = "profile-pic.png"
  source       = "profile-pic.png"
  acl          = "public-read"
  content_type = "text/png"
}

#s3 static website configurations
resource "aws_s3_bucket_website_configuration" "s3-static-website" {
  bucket = aws_s3_bucket.s3-static-portfolio.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_acl.s3-static-portfolio]
}



