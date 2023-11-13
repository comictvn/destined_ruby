terraform {
  backend "s3" {
    bucket                  = "<<PLACEHOLDER>>"
    key                     = "kevin-july-staging/terraform.tfstate"
    region                  = "ap-northeast-1"
  }
}
