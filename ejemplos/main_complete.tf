provider "aws" {
    region = "us-east-2"
}

module "nlb" {
    source = "../../terraform-aws-nlb/"
    name = "dev-chule-nlb"
    internal = true
    subnet_id = "subnet-6e6d9814"
}
module "vpc_link" {
    source = "../../terraform-aws-vpc-link/"
    vpc_link_name = "vpc-link-test"
    vpc_link_description = "yet another vpc link"
    target_arns = [module.nlb.execution_arn]
}

module "api_gateway_bis" {
  source  = "../"
  name    = "dev-prueba"
  enabled = true

  # Api Gateway Resource
  path_parts = ["demo"]

  # Api Gateway Method
  method_enabled = true
  http_methods   = ["ANY"]


  # Api Gateway Integration
  integration_types        = ["HTTP_PROXY"]
  connection_types         = ["VPC_LINK"]
  connection_ids            = [module.vpc_link.vpc_link_id]
  integration_http_methods = ["ANY"]
  uri                      = ["https://api-users.ticmas.vi-datec.com/apiv1/curricula/"]


  # Api Gateway Request Parameters

  # Api Gateway Method Response
  status_codes        = [200]
  response_models     = [{ "application/json" = "Empty" }]
  response_parameters = [{ "method.response.header.X-Some-Header" = true }]

  # Api Gateway Integration Response
  integration_response_parameters = [{ "method.response.header.X-Some-Header" = "integration.response.header.X-Some-Other-Header" }]
  response_templates = [{
    "application/xml" = <<EOF
  #set($inputRoot = $input.path('$'))
  <?xml version="1.0" encoding="UTF-8"?>
  <message>
      $inputRoot.body
  </message>
  EOF
  }]

  # Api Gateway Deployment
  deployment_enabled = true
  stage_name         = "deploy"
  deploy_description = "v2"

  # Api Gateway Stage
  stage_enabled = true
  stage_names   = ["demo"]
}