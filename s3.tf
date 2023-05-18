####CREATE THE S3 BUCKET

resource "aws_s3_bucket" "mys3" {
  bucket = var.bucket_name
  tags = {
    Name        = var.bucket_name
    
  }
}
