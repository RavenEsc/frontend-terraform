# the bucket
resource "aws_s3_bucket" "buck" {
  bucket = var.bucketname

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
# the configs
resource "aws_s3_bucket_website_configuration" "config" {
  bucket = aws_s3_bucket.buck.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
# the main page html file
resource "aws_s3_object" "index" {
  bucket = var.bucketname
  key    = "index.html"
  source = "Web-Frontend/index.html"
}
# the error page html file
resource "aws_s3_object" "error" {
  bucket = var.bucketname
  key    = "error.html"
  source = "Web-Frontend/error.html"
}
# the stylesheet css file
resource "aws_s3_object" "csstyle" {
  bucket = var.bucketname
  key    = "style.css"
  source = "Web-Frontend/my-css-for-resume.css"
}

# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   bucket = aws_s3_bucket.buck.id
#   policy = data.aws_iam_policy_document.example.json
# }

# data "aws_iam_policy_document" "allow_access_from_another_account" {
#   statement {

#     principals {
#       type        = "AWS"
#       identifiers = [""]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       aws_s3_bucket.buck.arn,
#       "${aws_s3_bucket.buck.arn}/*",
#     ]
#   }
# }

resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket = aws_s3_bucket.buck.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}