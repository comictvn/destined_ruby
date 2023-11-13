terraform {
  backend "s3" {
    bucket                  = "<<PLACEHOLDER>>"
    key                     = "kevin-july-development/terraform.tfstate"
    region                  = "ap-northeast-1"
  }
}
