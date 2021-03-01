resource "aws_s3_bucket" "assets" {
  bucket = "${var.project_name_env}-assets"
}

# S3 user

resource "aws_iam_user" "s3_user" {
  name = "${var.project_name_env}-s3-bucket-user"
}

data "aws_iam_policy_document" "s3_user" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.assets.bucket}"
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.assets.bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_user" {
  name   = "${var.project_name_env}-s3-bucket-user"
  policy = data.aws_iam_policy_document.s3_user.json
}

resource "aws_iam_user_policy_attachment" "s3_user" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_user.arn
}
