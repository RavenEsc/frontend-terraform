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

  routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "../"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": ""
    }
}]
EOF
}

# Upload the index.html file to the S3 bucket
resource "aws_s3_object" "error" {
  bucket = var.bucketname
  content_type = "text/html"
  server_side_encryption = "AES256"
  key    = "error.html"
  content = file("Web-Frontend/error.html")

  depends_on = [ aws_s3_bucket.buck ]
}

# Upload the style.css file to the S3 bucket
resource "aws_s3_object" "csstyle" {
  bucket = var.bucketname
  content_type = "text/css"
  server_side_encryption = "AES256"
  key    = "styles.css"
  content = file("Web-Frontend/styles.css")

  depends_on = [ aws_s3_bucket.buck ]
}

# Upload the style.css file to the S3 bucket
resource "aws_s3_object" "terminal" {
  bucket = var.bucketname
  content_type = "text/js"
  server_side_encryption = "AES256"
  key    = "terminal.js"
  content = file("Web-Frontend/terminal.js")

  depends_on = [ aws_s3_bucket.buck ]
}

# Create the S3 bucket policy resource to give public access to the web page
resource "aws_s3_bucket_policy" "pubilc-policy" {
  bucket = aws_s3_bucket.buck.id
  policy = templatefile("./s3-policy.json", { bucket = var.bucketname })
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
