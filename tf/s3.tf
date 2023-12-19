# Create an S3 bucket resource with specified name and tags
resource "aws_s3_bucket" "buck" {
  bucket = var.bucketname
  force_destroy = true
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

resource "aws_s3_object" "test" {
  for_each = fileset("${var.s3_upload_dir}", "**")
  bucket = var.bucketname
  key = each.value
  source = "${var.s3_upload_dir}${each.value}"
  etag = filemd5("${var.s3_upload_dir}${each.value}")
}

# Create the S3 bucket policy resource to give public access to the web page
resource "aws_s3_bucket_policy" "pubilc-policy" {
  bucket = aws_s3_bucket.buck.id
  policy = templatefile("./json/s3-policy.json", { bucket = var.bucketname })
  depends_on = [ aws_s3_bucket.buck ]
}

# Block public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket = aws_s3_bucket.buck.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
