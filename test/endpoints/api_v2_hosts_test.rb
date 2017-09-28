require File.expand_path '../../test_helper.rb', __FILE__

class ApiEndPointsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # ---------------------------------------------------------------------------
  # GET
  # ---------------------------------------------------------------------------
  def test_root_endpoint
    get '/'

    response = last_response.body

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "Welcome To Our API V2 Playground", response
  end

  def test_api_v2_hosts
    get '/api/v2/hosts'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal Hash.new, json_rsp['data']
  end

  def test_api_v2_hosts_with_id
    get '/api/v2/hosts/?id=14'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['id']
    assert_equal "", json_rsp['data']['name']
  end

  def test_api_v2_hosts_with_id_and_hostname
    get '/api/v2/hosts/?id=14&name=lnsx10002.oracle.com'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['id']
    assert_equal "lnsx10002.oracle.com", json_rsp['data']['name']
  end

  def test_api_v2_hosts_with_hostname
    get '/api/v2/hosts/?name=lnsx10002.oracle.com'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "", json_rsp['data']['id']
    assert_equal "lnsx10002.oracle.com", json_rsp['data']['name']
  end

  def test_api_v2_hosts_no_id_no_hostname
    get '/api/v2/hosts/'

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal 400, last_response.status
  end

  # ---------------------------------------------------------------------------
  # POST
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_post
    #raw_body = '{"hostname": "sumhost01.us.oracle.com","total_memory": 20119, "total_swap": 23191, "cpu_count": 8}'
    raw_body = File.read('test/fixtures/json_files/host_minimal.json')
    post '/api/v2/hosts', raw_body, format: :json

    response  = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "POST", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "devboxDIS", json_data['hostname']
    assert_equal 2, json_data['cpu_count']
  end
  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # PUT
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_put_with_id
    raw_body = '{"hostname": "sumhost01.us.oracle.com","total_memory": 20119, "total_swap": 23191, "cpu_count": 12}'
    put '/api/v2/hosts/?id=14', raw_body

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['id']
    assert_nil json_rsp['data']['name']
  end

  def test_api_v2_hosts_put_with_hostname
    raw_body = '{"hostname": "sumhost01.us.oracle.com","total_memory": 40224, "total_swap": 28024, "cpu_count": 12}'
    put '/api/v2/hosts/?name=lnsx10002.oracle.com', raw_body

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", json_rsp['status']
    assert_nil json_rsp['data']['id']
    assert_equal "lnsx10002.oracle.com", json_rsp['data']['name']
  end

  def test_api_v2_hosts_put_with_id_and_hostname
    raw_body = '{"hostname": "sumhost01.us.oracle.com","total_memory": 40224, "total_swap": 28024, "cpu_count": 12}'
    put '/api/v2/hosts/?id=14&name=lnsx10002.oracle.com', raw_body

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['id']
    assert_equal "lnsx10002.oracle.com", json_rsp['data']['name']
  end

  def test_api_v2_hosts_put_no_id_and_no_hostname
    raw_body = '{"hostname": "dumhost07.us.oracle.com"}'
    put '/api/v2/hosts/', raw_body

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 404, last_response.status
  end
  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # PATCH
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_patch_with_id
    raw_body = '{"hostname": "sumhost01.us.oracle.com","cpu_count": 24}'
    patch '/api/v2/hosts/?id=14', raw_body

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['id']
    assert_nil json_rsp['data']['name']
  end

  def test_api_v2_hosts_patch_with_hostname
    raw_body = '{"hostname": "sumhost01.us.oracle.com","total_swap": 20248}'
    patch '/api/v2/hosts/?name=lnsx10002.oracle.com', raw_body

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", json_rsp['status']
    assert_nil json_rsp['data']['id']
    assert_equal "lnsx10002.oracle.com", json_rsp['data']['name']
  end

  def test_api_v2_hosts_patch_with_id_and_hostname
    raw_body = '{"hostname": "dumhost07.us.oracle.com"}'
    patch '/api/v2/hosts/?id=14&name=lnsx10002.oracle.com', raw_body

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['id']
    assert_equal "lnsx10002.oracle.com", json_rsp['data']['name']
  end

  def test_api_v2_hosts_patch_no_id_and_no_hostname
    raw_body = '{"hostname": "dumhost07.us.oracle.com"}'
    patch '/api/v2/hosts/', raw_body

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 404, last_response.status
  end
  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # DELETE
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_delete_with_id
    delete '/api/v2/hosts/?id=14'

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
  end

  def test_api_v2_hosts_delete_with_hostname
    delete '/api/v2/hosts/?name=lnsx10002.oracle.com'

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
  end

  def test_api_v2_hosts_delete_with_id_and_hostname
    delete '/api/v2/hosts/?id=14&name=lnsx10002.oracle.com'

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
  end

  def test_api_v2_hosts_delete_no_id_no_hostname
    delete '/api/v2/hosts/'

    assert_equal 404, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
  end
  # ---------------------------------------------------------------------------

end
