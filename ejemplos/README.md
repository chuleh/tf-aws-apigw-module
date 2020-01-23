# Terraform AWS API Gateway
Para poder usar el template es necesario primero clonarse el repo.
Una vez clonado, tenemos que crear un archivo `.tf` que puede llevar cualquier nombre
y no olvidar hacerle source al módulo llamándole desde el PATH relativo en donde estamos.

Ejemplo:
```
source  = "./terraform-aws-apigw"
```

Si quisiéramos usar el módulo sin clonar, deberíamos cambiar el source a:
```
source = "git::git@gitlab.com:vidatec-devops/terraform/terraform-aws-apigw.git"
```

## Integración con otros módulos
El módulo está pensado para poder integrarse con otros módulos, ya sea el de `NLB` o `VPC_LINK` o el
de crear un `VPC` completa desde cero.
De hecho, si queremos crear un recurso en API GW con el tipo de conexión `VPC_LINK` y la integración
`HTTP_PROXY` es recomendable usar estos módulos en el mismo archivo `.tf` e ir llamándolos uno por uno.

Ver el archivo `main_complete.tf`, donde por ejemplo se van llamando los módulos entre sí y el output
de uno, es el input del otro, por ejemplo:

```
connection_ids            = [module.vpc_link.vpc_link_id]
```

No olvidar cambiar la región a la que estemos usando.
Otra variable a tener en cuenta si vamos a crear todo el stack como en el ejemplo `main_complete.tf`
es la de pasarle el `subnet_id`.

```
subnet_id = "subnet-6e6d9814"
```

Por el momento, por una limitación al crearse en TF, sólo acepta una subnet como variable.
Si el NLB es interno, entonces la `subnet` tiene que ser una privada.