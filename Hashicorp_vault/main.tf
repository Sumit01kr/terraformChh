provider "aws" {
  region = "ap-south-1"
}


provider "vault" {
  address           = "http://15.206.73.226:8200"
  skip_child_token  = true

  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = "44d7dd6b-e9b9-8c67-363e-1299409c83f5"
      secret_id = "8255cad9-2247-6c8f-a8f6-62611699fe01"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret"
  name  = "kv/sumit"
}



