data "aws_iam_user" "minio_backup" {
  user_name = var.existing_iam_user_name
}

resource "aws_iam_policy" "minio_backup_policy" {
  name = "${var.project_name}-minio-backup-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.minio_backup.arn,
          "${aws_s3_bucket.minio_backup.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = data.aws_iam_user.minio_backup.user_name
  policy_arn = aws_iam_policy.minio_backup_policy.arn
}