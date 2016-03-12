require 'trello'

include Trello
include Trello::Authorization

trello_key = ENV["TRELLO_PUBLIC_KEY"]
trello_secret = ENV["TRELLO_SECRET_KEY"]
trello_token = ENV["TRELLO_TOKEN"]

OAuthPolicy.consumer_credential = OAuthCredential.new trello_key, trello_secret
OAuthPolicy.token = OAuthCredential.new trello_token, nil

Trello.configure do |config|
  config.developer_public_key = trello_key
  config.member_token = trello_token
end
