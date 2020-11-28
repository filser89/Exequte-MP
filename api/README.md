Rails API for WeChat MiniPrograms.

  ## Credentials set-up
  #### In order to use this template set up the following values in config/credentials.yml.enc

  api_key: [YOUR-API-KEY]
jwt_token_secret_key: [YOUR-JWT-TOKEN]
jwt_expiration_seconds: [TOKEN-EXPIRSTION-IN-SECONDS (Recommended: 900)]
wx_mp_app_id: [YOUR-APP-ID (provided by WECHAT)]
wx_mp_app_secret: [YOUR-APP-SECRET (provided by WECHAT)]

## API
- each API call must include API-Key in request headers
- only /api/v1/users/wx_login do not need X-Auth-Token in request headers
  - after wx_login, user returned with an auto_token, after that, every API request will include the auth_token in header as X-Auth-Token
  - the auth_token used to indentify a user from DB, in each controlers the method current_user is the user made the API request
  - User has a instance method #token to generate a token for test, User.first.token => token string

  ## Architecture
  MVC S
  - S is service: wechat open id, token. Defined in app/services
  - It is recommended to directlly render json in controllers, with two instance methods in model return hash for json format, Model#index_hash, Model#show_hash (see app/models/user.rb for reference)
  - Change the #index_hash and #show_hash methods OR add more similar methods to return the data needed in MP


