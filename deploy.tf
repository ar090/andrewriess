#
# Backend
#

terraform { backend "s3" { } }

#
# S3 Bucket
#

resource "aws_s3_bucket" "andrewriess" {
    bucket = "andrew-riess-site"

    cors_rule {
        allowed_methods = ["GET", "HEAD"]
        allowed_origins = ["*"]
    }

    website {
        index_document = "index.html"
        error_document = "index.html"
    }
}

resource "aws_s3_bucket_policy" "andrewriess" {
    bucket = "${aws_s3_bucket.andrewriess.id}"
    policy = "${data.aws_iam_policy_document.andrewriess.json}"
}

data "aws_iam_policy_document" "andrewriess" {
    statement {
        actions = ["s3:GetObject"]
        resources = ["arn:aws:s3:::${aws_s3_bucket.andrewriess.id}/*"]

        principals {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}