# S3 ReadOnly User

data "aws_iam_policy_document" "read_only" {
  statement {
      effect = "Allow"
      actions = [ "s3:GetObject" ]
      resources = [
        "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }
}

resource "aws_iam_user" "s3_read_only" {
  name = "s3-read-only"

  tags = {
    tag-key = "s3-read-only"
  }
}

resource "aws_iam_access_key" "s3_read_only" {
  user = aws_iam_user.s3_read_only.name
}

resource "aws_iam_user_policy" "s3_read_only" {
  name = "read-only-policy"
  user = aws_iam_user.s3_read_only.name
  policy = data.aws_iam_policy_document.read_only.json
}

# S3 Read Write user

data "aws_iam_policy_document" "read_write" {
  statement {
      sid = "ListObjectsInBucket"
      effect = "Allow"
      actions = [ "s3:ListBucket" ]
      resources = [
        "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }
  statement {
      sid = "AllObjectActions"
      effect = "Allow"
      actions = [ "s3:*Object*" ]
      resources = [
        "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }
}

resource "aws_iam_user" "s3_read_write" {
  name = "s3-read-write"

  tags = {
    tag-key = "s3-read-write"
  }
}

resource "aws_iam_access_key" "s3_read_write" {
  user = aws_iam_user.s3_read_write.name
}

resource "aws_iam_user_policy" "s3_read_write" {
  name = "read-write-policy"
  user = aws_iam_user.s3_read_write.name
  policy = data.aws_iam_policy_document.read_write.json
}
