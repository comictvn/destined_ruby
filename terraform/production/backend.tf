terraform {
  backend "s3" {
    bucket                  = "<<PLACEHOLDER>>"
    key                     = "kevin-july-production/terraform.tfstate"
    region                  = "ap-northeast-1"
  }
}
