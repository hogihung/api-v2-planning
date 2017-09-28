require File.expand_path '../../test_helper.rb', __FILE__

class ApiEndPointsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # ---------------------------------------------------------------------------
  # GET
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_mounts
    get '/api/v2/hosts/14/mounts'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['host_id']  # TODO: IMPROVE LATER WITH DATA
  end

  def test_api_v2_hosts_hostname_mounts
    get '/api/v2/hosts/bobot.oscar.com/mounts'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "bobot.oscar.com", json_rsp['data']['hostname']  # TODO: IMPROVE LATER WITH DATA
  end

  def test_api_v2_hosts_id_mounts_mount_id
    get '/api/v2/hosts/14/mounts/69'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "14", json_rsp['data']['id']
    assert_equal "69", json_rsp['data']['mount_id']
  end

  def test_api_v2_hosts_hostname_mounts_mount_id
    get '/api/v2/hosts/bobot.oscar.com/mounts/69'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "bobot.oscar.com", json_rsp['data']['hostname']
    assert_equal "69", json_rsp['data']['mount_id']
  end

  def test_api_v2_hosts_id_mounts_no_mount_id
    get '/api/v2/hosts/14/mounts/'

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal 404, last_response.status
  end

  def test_api_v2_hosts_hostname_mounts_no_mount_id
    get '/api/v2/hosts/bobot.oscar.com/mounts/'

    assert_equal "GET", last_request.env["REQUEST_METHOD"]
    assert_equal 404, last_response.status
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # POST
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_mounts_post
    raw_body = File.read('test/fixtures/json_files/host_with_id_mounts_minimal.json')
    post '/api/v2/hosts/14/mounts', raw_body, format: :json

    response  = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "POST", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "2046", json_data['host_id']
    assert_equal 2, json_data['mounts'].count
  end

  def test_api_v2_hosts_id_mounts_post
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_mounts_minimal.json')
    post '/api/v2/hosts/bobot.oscar.com/mounts', raw_body, format: :json

    response  = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "POST", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "bobot.oscar.com", json_data['host_name']
    assert_equal 2, json_data['mounts'].count
    assert_equal "/", json_data['mounts'][0]['path']
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # PUT
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_mounts_put
    raw_body = File.read('test/fixtures/json_files/host_with_id_mounts_minimal.json')
    put '/api/v2/hosts/14/mounts', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "2046", json_data['host_id']
    assert_equal 2, json_data['mounts'].count
  end

  def test_api_v2_hosts_hostname_mounts_put
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_mounts_minimal.json')
    put '/api/v2/hosts/bobot.oscar.com/mounts', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PUT", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "bobot.oscar.com", json_data['host_name']
    assert_equal 2, json_data['mounts'].count
    assert_equal "/", json_data['mounts'][0]['path']
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # PATCH
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_id_mounts_patch
    raw_body = File.read('test/fixtures/json_files/host_with_id_mounts_minimal_patch.json')
    patch '/api/v2/hosts/14/mounts', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "2046", json_data['host_id']
    assert_equal "rw+", json_data['mounts'][0]['mntops']
    assert_equal "/dev/ops", json_data['mounts'][0]['path']
  end

  def test_api_v2_hosts_hostname_mounts_patch
    raw_body = File.read('test/fixtures/json_files/host_with_hostname_mounts_minimal_patch.json')
    patch '/api/v2/hosts/bobot.oscar.com/mounts', raw_body

    response = last_response.body
    parse_rsp = JSON.parse(response)
    json_data = JSON.parse(parse_rsp['data'])

    assert_equal "PATCH", last_request.env["REQUEST_METHOD"]
    assert_equal 200, last_response.status
    assert_equal "OK", parse_rsp['status']
    assert_equal "nurny.oscar.com", json_data['host_name']
    assert_equal "rw+", json_data['mounts'][0]['mntops']
    assert_equal "/dev/ops", json_data['mounts'][0]['path']
  end
  # ---------------------------------------------------------------------------


  # ---------------------------------------------------------------------------
  # DELETE
  # ---------------------------------------------------------------------------
  def test_api_v2_hosts_delete_with_id
    delete '/api/v2/hosts/14/mounts'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "4", json_rsp['num_rows']
  end

  def test_api_v2_hosts_delete_with_hostname
    delete '/api/v2/hosts/bobot.oscar.com/mounts'

    response = last_response.body
    json_rsp = JSON.parse(response)

    assert_equal 200, last_response.status
    assert_equal "DELETE", last_request.env["REQUEST_METHOD"]
    assert_equal "OK", json_rsp['status']
    assert_equal "8", json_rsp['num_rows']
  end
  # ---------------------------------------------------------------------------

end
