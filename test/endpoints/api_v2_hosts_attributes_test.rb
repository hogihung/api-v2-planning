require File.expand_path '../../test_helper.rb', __FILE__

class ApiEndPointsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # ---------------------------------------------------------------------------
  # GET
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_attributes
    get '/api/v2/hosts/14/attributes'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['host_id']  # TODO: IMPROVE LATER WITH DATA
  end

  def test_api_v2_hosts_hostname_attributes
    get '/api/v2/hosts/bobot.oscar.com/attributes'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "bobot.oscar.com", json_rsp['data']['hostname']  # TODO: IMPROVE LATER WITH DATA
  end

  def test_api_v2_hosts_id_attributes_attr_id
    get '/api/v2/hosts/14/attributes/69'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['id']
    assert_equal "69", json_rsp['data']['attribute_id']
  end

  def test_api_v2_hosts_hostname_attributes_attr_id
    get '/api/v2/hosts/bobot.oscar.com/attributes/69'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "bobot.oscar.com", json_rsp['data']['hostname']
    assert_equal "69", json_rsp['data']['attribute_id']
  end

  def test_api_v2_hosts_id_attributes_no_attr_id
    get '/api/v2/hosts/14/attributes/'

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal 404, last_response.status
  end

  def test_api_v2_hosts_hostname_attributes_no_attr_id
    get '/api/v2/hosts/bobot.oscar.com/attributes/'

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal 404, last_response.status
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # POST
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_attribute_post
    raw_body = File.read('test/fixtures/json_files/host_with_id_attrs_minimal.json')
    post '/api/v2/hosts/14/attributes', raw_body, format: :json

    response  = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "POST", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "14", json_data['host_id']
    assert_equal "devcc.oscar.com", json_data['em_host']
  end

  def test_api_v2_hosts_id_attributes_post
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_attrs_minimal.json')
    post '/api/v2/hosts/bobot.oscar.com/attributes', raw_body, format: :json

    response  = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "POST", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "bobot.oscar.com", json_data['host_name']
    assert_equal "devem.oscar.com", json_data['em_host']
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # PUT
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_attributes_put
    raw_body = File.read('test/fixtures/json_files/host_with_id_attrs_minimal.json')
    put '/api/v2/hosts/14/attributes', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "14", json_data['host_id']
    assert_equal "https://devcc.oscar.com:4890/empbs/upload", json_data['em_repository_url']
  end

  def test_api_v2_hosts_hostname_attributes_put
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_attrs_minimal.json')
    put '/api/v2/hosts/bobot.oscar.com/attributes', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "bobot.oscar.com", json_data['host_name']
    assert_equal "devem.oscar.com", json_data['em_host']
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # PATCH
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_attributes_patch
    raw_body = File.read('test/fixtures/json_files/host_with_id_attrs_minimal_patch.json')
    patch '/api/v2/hosts/14/attributes', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "14", json_data['host_id']
    assert_equal "https://devZZ.oscar.com:4890/empbs/upload", json_data['em_repository_url']
  end

  def test_api_v2_hosts_hostname_attributes_patch
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_attrs_minimal_patch.json')
    patch '/api/v2/hosts/bobot.oscar.com/attributes', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "bobot.oscar.com", json_data['host_name']
    assert_equal "devZZ.oscar.com", json_data['em_host']
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # DELETE
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_delete_with_id
    delete '/api/v2/hosts/14/attributes'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "3", json_rsp['num_rows']
  end

  def test_api_v2_hosts_delete_with_hostname
    delete '/api/v2/hosts/bobot.oscar.com/attributes'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "7", json_rsp['num_rows']
  end
  # ---------------------------------------------------------------------------
end
