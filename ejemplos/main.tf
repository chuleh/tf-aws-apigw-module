module "api_gateway" {
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
  connection_ids            = [completar con el vpc link id]
  integration_http_methods = ["ANY"]
  uri                      = ["completar con la URI"]

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
  stage_names   = ["prueba"]
}
