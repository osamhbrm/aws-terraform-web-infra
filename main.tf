module "vpc" {
  source = "./modules/vpc"
}
module "compute" {
  source                       = "./modules/compute"
  alb_sg                       = module.security.alb
  lb_target_group              = module.vpc.vpc
  instance_profile_web_profile = module.security.web_profile
  private_sg                   = module.security.private_sg
  public1                      = module.vpc.public1
  public2                      = module.vpc.public2
  private1                     = module.vpc.private1
  private2                     = module.vpc.private2

}
module "db" {
  source      = "./modules/database"
  private1_db = module.vpc.private1-db
  private2_db = module.vpc.private2-db
  db_sg       = module.security.db_sg

}
module "security" {
  source  = "./modules/security"
  SecretM = module.db.secret
  vpc     = module.vpc.vpc
}
