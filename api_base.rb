require 'sinatra'
require 'sinatra/json'
require 'sequel'
require 'pry'

# HELP GUIDE
# get    - retieve/show something
# post   - create something (create new record)
# put    - replace something (replace entire record of current record)
# patch  - modify some of the attributes of a record
# delete - remove a record

BASE_API_VERSION = '1.0.1-p092717'
API_SERVER = %x(hostname -f).chomp

VALID_HOST_NAME = /\w+\W+\w+\W\w+/   # need to improve this RegEx, very weak!!
VALID_POD_NAME = /\w+/   # need to improve this RegEx, very weak!!

class Object
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  def present?
    !blank?
  end

  def hash_with_key?(key)
    self.is_a?(Hash) && self.has_key?(key)
  end

  def hash_with_keys?(keys)
    return false unless self.is_a?(Hash)
    return false unless (keys.is_a?(Array) && keys.present?)

    has_keys = false
    keys.each do |key|
      has_keys = has_key?(key)
    end
    has_keys
  end
end

helpers do
  def validate_required_params(primary, secondary, response_code)
    (primary.present? || secondary.present?) || halt(response_code)
  end
end

# -----------------------------------------------------------------------------
# UTILITY
# -----------------------------------------------------------------------------
get '/api/v2/ping' do
  json({:status => "OK", :data => Time.now})
end

get '/api/v2/version' do
  json({:status => "OK",
        :data => {:base_api => "#{BASE_API_VERSION}",
                  :host_server => "#{API_SERVER}"}})
end
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Host
# -----------------------------------------------------------------------------
get '/' do
  # http://localhost:4567/
  'Welcome To Our API V2 Playground'
end

get '/api/v2/hosts' do
  # http://localhost:4567/api/v2/hosts
  # Retrieve list of all hosts
  json({:status => "OK", :data => {}})
end

get '/api/v2/hosts/?' do
  # http://localhost:4567/api/v2/hosts/?id=14
  #   -OR-
  # http://localhost:4567/api/v2/hosts/?name=bobot.oscar.com
  # Retrieve host based on id or hostname
  host_id  = params['id']   || ''
  host_name = params['name'] || ''

  validate_required_params(host_id, host_name, 400) # (if neither id nor name, respond with 400
  json({:status => "OK", :data => {id: host_id, name: host_name} })
end

post '/api/v2/hosts' do
  # http://localhost:4567/api/v2/hosts
  # Create a Host Record
  incoming_data = request.body.read
  json({:status => "OK", :data => incoming_data})
end

put '/api/v2/hosts/?' do
  # http://localhost:4567/api/v2/hosts/?id=14
  #   -OR-
  # http://localhost:4567/api/v2/hosts/?name=bobot.oscar.com
  # Replace the existing host record
  host_id   = params['id']
  host_name = params['name']
  incoming_data = request.body.read

  if host_id || host_name
    json({:status => "OK", :data => {id: host_id, name: host_name, data: incoming_data} })
  else
    status 404
  end
end

patch '/api/v2/hosts/?' do
  # http://localhost:4567/api/v2/hosts/?id=14
  #   -OR-
  # http://localhost:4567/api/v2/hosts/?name=bobot.oscar.com
  # Update some of the attributes of a host record
  host_id   = params['id']
  host_name = params['name']
  incoming_data = request.body.read

  if host_id || host_name
    json({:status => "OK", :data => {id: host_id, name: host_name, data: incoming_data} })
  else
    status 404
  end
end

delete '/api/v2/hosts/?' do
  # http://localhost:4567/api/v2/hosts/?id=14
  #   -OR-
  # http://localhost:4567/api/v2/hosts/?name=bobot.oscar.com
  # Delete the record for give host
  host_id   = params['id']
  host_name = params['name']

  if host_id || host_name
    "I would delete the record for host (id = #{host_id})"
  else
    status 404
  end
end
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Host Attributes
# -----------------------------------------------------------------------------
# NOTE: Order is important - be mindful when trying to match on similar routes
get %r{/api/v2/hosts/([\d]+)/attributes/([\d]+)} do |host_id, attr_id|
  # http://localhost:4567/api/v2/hosts/14/attributes/69
  host_id = params['captures'][0]
  attr_id = params['captures'][1]

  if host_id && attr_id
    json({status: "OK", data: {id: host_id, attribute_id: attr_id}})
  else
    status 404
  end
end

get %r{/api/v2/hosts/(#{VALID_HOST_NAME})/attributes/([\d]+)} do |name, attr_id|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/attributes/69
  hostname = params['captures'][0]
  attr_id  = params['captures'][1]

  if hostname && attr_id
    json({status: "OK", data: {hostname: hostname, attribute_id: attr_id}})
  else
    status 404
  end

end

get %r{/api/v2/hosts/([\d]+)/attributes$} do |id|
  # http://localhost:4567/api/v2/hosts/14/attributes
  host_id   = params['captures'][0]
  json({status: "OK", data: {host_id: host_id}})
end

# Will we need to use a get for attributes using hostname?
get %r{/api/v2/hosts/(#{VALID_HOST_NAME})/attributes$} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/attributes
  host_name = params['captures'][0]
  json({status: "OK", data: {hostname: host_name}})
end

post %r{/api/v2/hosts/([\d]+)/attributes} do |id|
  # http://localhost:4567/api/v2/hosts/14/attributes
  # Create host attributes for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

post %r{/api/v2/hosts/(#{VALID_HOST_NAME})/attributes} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/attributes
  # Create host attributes for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

put %r{/api/v2/hosts/([\d]+)/attributes} do |id|
  # http://localhost:4567/api/v2/hosts/14/attributes
  # Create host attributes for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

put %r{/api/v2/hosts/(#{VALID_HOST_NAME})/attributes} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/attributes
  # Create host attributes for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

patch %r{/api/v2/hosts/([\d]+)/attributes} do |id|
  # http://localhost:4567/api/v2/hosts/14/attributes
  # Create host attributes for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

patch %r{/api/v2/hosts/(#{VALID_HOST_NAME})/attributes} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/attributes
  # Create host attributes for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

delete %r{/api/v2/hosts/([\d]+)/attributes} do |id|
  json({status: "OK", num_rows: "3"})
end

delete %r{/api/v2/hosts/(#{VALID_HOST_NAME})/attributes} do |name|
  json({status: "OK", num_rows: "7"})
end
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Host Interfaces
# -----------------------------------------------------------------------------
# NOTE: Order is important - be mindful when trying to match on similar routes
get %r{/api/v2/hosts/([\d]+)/interfaces/([\d]+)} do |host_id, ifaces_id|
  # http://localhost:4567/api/v2/hosts/2046/interfaces/76
  host_id       = params['captures'][0]
  interface_id = params['captures'][1]

  if host_id && interface_id
    json({status: "OK", data: {id: host_id, interface_id: ifaces_id}})
  else
    status 404
  end
end

get %r{/api/v2/hosts/(#{VALID_HOST_NAME})/interfaces/([\d]+)} do |name, ifaces_id|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/interfaces/76
  hostname = params['captures'][0]
  interface_id  = params['captures'][1]

  if hostname && interface_id
    json({status: "OK", data: {hostname: hostname, interface_id: ifaces_id}})
  else
    status 404
  end

end

get %r{/api/v2/hosts/([\d]+)/interfaces$} do |id|
  # http://localhost:4567/api/v2/hosts/2046/interfaces
  host_id   = params['captures'][0]
  json({status: "OK", data: {host_id: host_id}})
end

# Will we need to use a get for attributes using hostname?
get %r{/api/v2/hosts/(#{VALID_HOST_NAME})/interfaces$} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/interfaces
  host_name = params['captures'][0]
  json({status: "OK", data: {hostname: host_name}})
end

post %r{/api/v2/hosts/([\d]+)/interfaces} do |id|
  # http://localhost:4567/api/v2/hosts/2046/interfaces
  # Create host interfaces for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

post %r{/api/v2/hosts/(#{VALID_HOST_NAME})/interfaces} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/interfaces
  # Create host interfaces for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

put %r{/api/v2/hosts/([\d]+)/interfaces} do |id|
  # http://localhost:4567/api/v2/hosts/2046/interfaces
  # Replace host interfaces for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

put %r{/api/v2/hosts/(#{VALID_HOST_NAME})/interfaces} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/interfaces
  # Replace host interfaces for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

patch %r{/api/v2/hosts/([\d]+)/interfaces} do |id|
  # http://localhost:4567/api/v2/hosts/2046/interfaces
  # Update host interfaces for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

patch %r{/api/v2/hosts/(#{VALID_HOST_NAME})/interfaces} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/interfaces
  # Update host interfaces for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

delete %r{/api/v2/hosts/([\d]+)/interfaces} do |id|
  json({status: "OK", num_rows: "2"})
end

delete %r{/api/v2/hosts/(#{VALID_HOST_NAME})/interfaces} do |name|
  json({status: "OK", num_rows: "3"})
end
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Host Mounts
# -----------------------------------------------------------------------------
# NOTE: Order is important - be mindful when trying to match on similar routes
get %r{/api/v2/hosts/([\d]+)/mounts/([\d]+)} do |host_id, mount_id|
  # http://localhost:4567/api/v2/hosts/14/mounts/69
  host_id  = params['captures'][0]
  mount_id = params['captures'][1]

  if host_id && mount_id
    json({status: "OK", data: {id: host_id, mount_id: mount_id}})
  else
    status 404
  end
end

get %r{/api/v2/hosts/(#{VALID_HOST_NAME})/mounts/([\d]+)} do |name, mount_id|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/mounts/69
  hostname = params['captures'][0]
  mount_id = params['captures'][1]

  if hostname && mount_id
    json({status: "OK", data: {hostname: hostname, mount_id: mount_id}})
  else
    status 404
  end

end

get %r{/api/v2/hosts/([\d]+)/mounts$} do |id|
  # http://localhost:4567/api/v2/hosts/14/mounts
  host_id   = params['captures'][0]
  json({status: "OK", data: {host_id: host_id}})
end

# Will we need to use a get for mounts using hostname?
get %r{/api/v2/hosts/(#{VALID_HOST_NAME})/mounts$} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/mounts
  host_name = params['captures'][0]
  json({status: "OK", data: {hostname: host_name}})
end

post %r{/api/v2/hosts/([\d]+)/mounts} do |id|
  # http://localhost:4567/api/v2/hosts/14/mounts
  # Create host mounts for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

post %r{/api/v2/hosts/(#{VALID_HOST_NAME})/mounts} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/mounts
  # Create host mounts for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

put %r{/api/v2/hosts/([\d]+)/mounts} do |id|
  # http://localhost:4567/api/v2/hosts/14/mounts
  # Replace host mounts for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

put %r{/api/v2/hosts/(#{VALID_HOST_NAME})/mounts} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/mounts
  # Replace host mounts for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

patch %r{/api/v2/hosts/([\d]+)/mounts} do |id|
  # http://localhost:4567/api/v2/hosts/14/mounts
  # Update host mounts for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

patch %r{/api/v2/hosts/(#{VALID_HOST_NAME})/mounts} do |name|
  # http://localhost:4567/api/v2/hosts/bobot.oscar.com/mounts
  # Update host mounts for a given Host
  incoming_data = request.body.read
  json({status: "OK", data: incoming_data})
end

delete %r{/api/v2/hosts/([\d]+)/mounts} do |id|
  json({status: "OK", num_rows: "4"})
end

delete %r{/api/v2/hosts/(#{VALID_HOST_NAME})/mounts} do |name|
  json({status: "OK", num_rows: "8"})
end
# -----------------------------------------------------------------------------

