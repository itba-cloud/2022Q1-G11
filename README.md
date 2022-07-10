# Cloud Computing

## TP3: Deployment recursos de infraestructura

### Instituto Tecnológico de Buenos Aires (ITBA)

### Autores

- [Sicardi, Julián Nicolas](https://github.com/Jsicardi) - Legajo 60347
- [Quintairos, Juan Ignacio](https://github.com/juaniq99) - Legajo 59715
- [Camila Borinsky](https://github.com/camilaborinsky) - Legajo 60083
- [Agustin Tormakh](https://github.com/atormakh) - Legajo 60041

## Índice

- [Autores](#autores)
- [Índice](#índice)
- [Descripción](#descripción)
- [Ejecucion](#ejecucion)
- [Requerimientos del TP](#requerimientos-del-tp)
  - [1. Uso de modulos](#1.uso-de-modulos)
  - [2. Uso de variables y outputs](#2.uso-de-variables-y-outputs)
  - [3. Uso de funciones](#3.uso-de-funciones)
    - [Type Conversion functions](#type-conversion-functions)
    - [Collection functions](#collection-functions)

## Descripción

El proyecto consiste en una aplicacion web que permite a un recruiter hacer busquedas sobre posibles candidatos en base a su experiencia en el uso de lenguajes o herramientas, basado en informacion extraida de la API de Github, que es procesada internamente por la infraestructura actual.

## Ejecucion

Para ejecutar el proyecto se debe primero actualizar el archivo `~/.aws/credentials` con las credenciales apropiadas de la cuenta de AWS a utilizar. Luego ejecutar los comandos:

```bash
$ cd terraform/organization
$ terrafom init
$ terrafom plan
```

## Componentes deployados

1. Bucket de sitio estático
2. Distribuciones de Cloudfront (API GW, static website)
3. Lambda queries de usuario
4. Lambda data ingestion
5. Bucket de data-curated
6. Bucket de raw-data
7. Api gateway
8. EventBridge

## Requerimientos del TP

#### 1. Uso de módulos

Definimos módulos para encapsular el comportamiento de los serivicios de AWS utilizados. Estos se encuentran en `./modules`:

- S3
- Api Gateway
- Event Bridge
- Cloudfront
- Lambda
- Network

#### 2. Uso de variables y outputs

Dentro de cada módulo hay un `variables.tf` que contiene las variables que espera recibir ese módulo cuando se utiliza con una descripción y un valor default si aplica. <br>
Ejemplo de uso de `./modules/lambda`:

```
module "lambda" {
  source = "./modules/lambda"

  providers = {
    aws = aws.aws
  }

  function_name = "my_lambda_function"
  handler = "my_lambda_function"
  runtime = "python3.9"
  desc = "Lambda function to execute user queries"
  filename = "pat_to_my_lambda_function.zip"
  iam_role_name = <role-name>
  iam_role_arn = "arn:aws:iam::<iam-number>:role/<iam-role>"
  iam_policy_name = "MyLambdaPolicy"
  iam_policy_content = <iam-policy-content>
  private_subnet_id = <subnet-id>
  lambda_sg_id = <sg-id>
}
```

Los parámetros que recibe el módulo son los definidos en su correspondiente: `./modules/lambda/variables.tf`<br>
Además hay un `outputs.tf` por cada módulo que define los valores de salida que se pueden acceder al utilizar un determnado módulo. En el caso de `./modules/lambda` el `module.lambda` devolvería un objeto del tipo:

```
{
    lambda_function_name: "my_lambda_function"
    lambda_function_arn: "arn::aws"
}
```

#### 3. Uso de al menos 4 funciones

https://www.terraform.io/language/functions

##### Type conversion functions

- `try()`: [ejemplo de uso](./main.tf)

##### Collection functions

- `lookup()`: [ejemplo de uso](./modules/cloudfront/main.tf)
- `length()`: [ejemplo de uso](./modules/cloudfront/main.tf)
- `keys()`: [ejemplo de uso](./modules/cloudfront/main.tf)

##### String functions

- `replace()`: [ejemplo de uso](./modules/s3_4.0/main.tf)
- `format()`: [ejemplo de uso](./modules/s3_4.0/main.tf)

#### 4. Uso de al menos 3 meta-argumentos

- `depends_on`: [ejemplo de uso](./main.tf)
- `for_each`: [ejemplo de uso](./main.tf)
- `count`: [ejemplo de uso](./modules/s3_4.0/main.tf)

#### Aclaración Athena

Implementamos la base de datos que usaríamos como target de las queries de Athena junto al bucket que sería el target y pasa el comando terraform plan. El problema es cuando quisimos probar con terraform apply este componente tardaba más de 20 minutos en crearse y seguía corriendo por lo que decidimos dejarlo comentado y no agregarlo al proyecto.
