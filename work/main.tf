module "eventbridge" {
    source = "./modules/eventbridge"
    lambda_arn = module.lambdad_weather_retrieve.lambda_arn
}

module "s3_landingbucket" {
    source = "./modules/s3_weather_landing"
 }

module "lambdad_weather_retrieve" {
    source = "./modules/lambda_weather_retrieve"
    s3_bucket = module.s3_landingbucket.landing_bucket_id
    lambda_name = "weather_retrieve"
}

module "s3_weather_transformed" {
    source = "./modules/s3_weather_transformed"
}

module "s3_events_to_lambda" {
   source = "./modules/s3_events_to_lambda"
   source_bucket = module.s3_landingbucket.landing_bucket_id
   lambda_arn =  module.lambdad_weather_etl.lambda_arn
}

module "lambdad_weather_etl" {
    source = "./modules/lambda_weather_etl"
    s3_bucket = module.s3_landingbucket.landing_bucket_id
    lambda_name = "weather_etl"
    #TO DO - Add S3 permissions to read weather_landing and weather_transformed
}
