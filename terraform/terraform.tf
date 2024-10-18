terraform {
  backend "s3" {
    bucket         = "r3m0t3-s3-bucket"           # Replace it with your bucket name for remote backend
    key            = "mern-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-table"      # Replace it with your dynamodb table name for remote backend
  }
}