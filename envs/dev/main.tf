terraform { required_version = ">= 1.5.0" }
module "s3" { source = "../../modules/s3" bucket_name = "example-change-me" }
