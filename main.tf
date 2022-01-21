terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}

module "exam_bot" {
  source = "./modules/bot"

  bucket_name          = "test.exams.ng"
  lambda_function_name = var.lambda_function_name
  PAGE_ID              = var.PAGE_ID
  PAGE_ACCESS_TOKEN    = var.PAGE_ACCESS_TOKEN
  API_URL              = var.API_URL
}


module "exam_api" {
  source = "./modules/apiGateway"

  lambda_function_arn  = module.exam_bot.exam_bot_lambda_arn
  lambda_function_name = var.lambda_function_name
}