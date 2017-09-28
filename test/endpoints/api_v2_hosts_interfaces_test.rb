require File.expand_path '../../test_helper.rb', __FILE__

class ApiEndPointsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # ---------------------------------------------------------------------------
  # GET
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_interfaces
    get '/api/v2/hosts/2046/interfaces'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "2046", json_rsp['data']['host_id']  # TODO: IMPROVE LATER WITH DATA
  end

  def test_api_v2_hosts_hostname_interfaces
    get '/api/v2/hosts/bobot.oscar.com/interfaces'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "bobot.oscar.com", json_rsp['data']['hostname']  # TODO: IMPROVE LATER WITH DATA
  end

  def test_api_v2_hosts_id_interfaces_ifaces_id
    get '/api/v2/hosts/2046/interfaces/76'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "2046", json_rsp['data']['id']
    assert_equal "76", json_rsp['data']['interface_id']
  end

  def test_api_v2_hosts_hostname_interfaces_ifaces_id
    get '/api/v2/hosts/bobot.oscar.com/interfaces/76'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "bobot.oscar.com", json_rsp['data']['hostname']
    assert_equal "76", json_rsp['data']['interface_id']
  end

  def test_api_v2_hosts_id_interfaces_no_ifaces_id
    get '/api/v2/hosts/2046/interfaces/'

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal 404, last_response.status
  end

  def test_api_v2_hosts_hostname_interfaces_no_ifaces_id
    #get '/api/v2/hosts/bobot.oscar.com/interfaces/'
    # TODO research why this doesn't match as expected with .oscar.com included.
    get '/api/v2/hosts/bobot/interfaces/'

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal 404, last_response.status
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # POST
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_attribute_post
    raw_body = File.read('test/fixtures/json_files/host_with_id_ifaces_minimal.json')
    post '/api/v2/hosts/2046/interfaces', raw_body, format: :json

    response  = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "POST", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "2046", json_data['host_id']
    assert_equal 2, json_data['interfaces'].count
  end

  def test_api_v2_hosts_id_interfaces_post
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_ifaces_minimal.json')
    post '/api/v2/hosts/bobot.oscar.com/interfaces', raw_body, format: :json

    response  = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "POST", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "nurny.oscar.com", json_data['host_name']
    assert_equal 2, json_data['interfaces'].count
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # PUT
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_interfaces_put
    raw_body = File.read('test/fixtures/json_files/host_with_id_ifaces_minimal.json')
    put '/api/v2/hosts/2046/interfaces', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "2046", json_data['host_id']
    assert_equal "10.0.2.0", json_data['interfaces'][0]['base_addr']
  end

  def test_api_v2_hosts_hostname_interfaces_put
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_ifaces_minimal.json')
    put '/api/v2/hosts/bobot.oscar.com/interfaces', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "nurny.oscar.com", json_data['host_name']
    assert_equal "10.0.2.0", json_data['interfaces'][0]['base_addr']
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # PATCH
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_interfaces_patch
    raw_body = File.read('test/fixtures/json_files/host_with_id_ifaces_minimal_patch.json')
    patch '/api/v2/hosts/2046/interfaces', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "2046", json_data['host_id']
    assert_equal "10.0.2.25", json_data['interfaces'][0]['ip_address']
    assert_equal "eth1", json_data['interfaces'][0]['name']
  end

  def test_api_v2_hosts_hostname_interfaces_patch
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_ifaces_minimal_patch.json')
    patch '/api/v2/hosts/bobot.oscar.com/interfaces', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "nurny.oscar.com", json_data['host_name']
    assert_equal "10.0.2.45", json_data['interfaces'][0]['ip_address']
    assert_equal "eth4", json_data['interfaces'][0]['name']
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # DELETE
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_delete_with_id
    delete '/api/v2/hosts/2046/interfaces'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "2", json_rsp['num_rows']
  end

  def test_api_v2_hosts_delete_with_hostname
    delete '/api/v2/hosts/bobot.oscar.com/interfaces'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "3", json_rsp['num_rows']
  end
  # ---------------------------------------------------------------------------

end
