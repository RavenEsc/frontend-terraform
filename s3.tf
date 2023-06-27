# Create an S3 bucket resource with specified name and tags
resource "aws_s3_bucket" "buck" {
  bucket = var.bucketname

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# Configure the website document and error pages for the S3 bucket
resource "aws_s3_bucket_website_configuration" "config" {
  bucket = aws_s3_bucket.buck.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Upload the index.html file to the S3 bucket
resource "aws_s3_object" "index" {
  bucket = var.bucketname
  content_type = "text/html"
  server_side_encryption = "AES256"
  key    = "index.html"
  source = "Web-Frontend/index.html"

  depends_on = [ aws_s3_bucket.buck ]
}

# Upload the error.html file to the S3 bucket
resource "aws_s3_object" "error" {
  bucket = var.bucketname
  content_type = "text/html"
  server_side_encryption = "AES256"
  key    = "error.html"
  source = "Web-Frontend/error.html"

  depends_on = [ aws_s3_bucket.buck ]
}

# Upload the style.css file to the S3 bucket
resource "aws_s3_object" "csstyle" {
  bucket = var.bucketname
  content_type = "text/css"
  server_side_encryption = "AES256"
  key    = "my-css-for-resume.css"
  source = "Web-Frontend/my-css-for-resume.css"

  depends_on = [ aws_s3_bucket.buck ]
}

# Create the S3 bucket policy resource to give public access to the web page
resource "aws_s3_bucket_policy" "pubilc-policy" {
  bucket = aws_s3_bucket.buck.id
  policy = templatefile("s3-policy.json", { bucket = var.bucketname })
}

# Block public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket = aws_s3_bucket.buck.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
