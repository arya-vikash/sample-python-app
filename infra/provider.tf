terraform {
  backend "s3" {
    bucket         = "rndm-smpl-tf-state-bucket"           
    key            = "terraform.tfstate" 
    region         = "eu-west-2"                   
    dynamodb_table = "rndm-smpl-tf-state-table"             
    encrypt        = true                          
  }
}