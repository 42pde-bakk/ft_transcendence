require "oauth2"
class HomeController < ApplicationController
  def index
    if (params[:code].present?)
      data = {grant_type: 'authorization_code', client_id: '0ebc0ed6e00f46a108cdcec53920e8bd00de8692aae747beee80e486feb5a6d2',
              client_secret: '66cb2e531d5ed30b5a53d185883f95964de1091cf1de07ece5766d04fa7830a6', code: params[:code],
              redirect_uri: 'http://127.0.0.1:3000/home'}
      uri = URI.parse('https://api.intra.42.fr/oauth/token')
      resp = Net::HTTP.post_form(uri, data)
    else
      redirect_to "https://api.intra.42.fr/oauth/authorize?client_id=0ebc0ed6e00f46a108cdcec53920e8bd00de8692aae747beee80e486feb5a6d2&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2Fhome&response_type=code"
  end
  end
  def auth
    redirect_to "https://api.intra.42.fr/oauth/authorize?client_id=0ebc0ed6e00f46a108cdcec53920e8bd00de8692aae747beee80e486feb5a6d2&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2Fhome&response_type=code"
  end
end
