require File.expand_path '../../test_helper.rb', __FILE__

class ApiEndPointsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_api_v2_ping
    get '/api/v2/ping'

    json_rsp = JSON.parse(last_response.body)
    assert last_response.ok?
    assert_equal "OK", json_rsp["status"]
  end

  def test_api_v2_version
    get '/api/v2/version'

    json_rsp = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal "1.0.1-p092717", json_rsp["data"]["base_api"]
    assert_equal "mac-n-cheese",  json_rsp["data"]["host_server"]
  end

end
