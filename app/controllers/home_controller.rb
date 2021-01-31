require "oauth2"
class HomeController < ApplicationController
  def index
  
  end
  def auth
    @UID = "0ebc0ed6e00f46a108cdcec53920e8bd00de8692aae747beee80e486feb5a6d2"
    @SECRET = "66cb2e531d5ed30b5a53d185883f95964de1091cf1de07ece5766d04fa7830a6"
    @client = OAuth2::Client.new(@UID, @SECRET, site: "https://api.intra.42.fr")
    redirect_to "https://api.intra.42.fr/oauth/authorize?client_id=0ebc0ed6e00f46a108cdcec53920e8bd00de8692aae747beee80e486feb5a6d2&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2Fhome&response_type=code"
    #@token = client.client_credentials.get_token
  end
end
