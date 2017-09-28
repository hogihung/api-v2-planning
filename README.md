# README

## API V2 Planning Playground

The purpose of this repo is to be used as a tool to assist us with the development
of a Sinatra (Ruby) based API.  This api planning tool is being built upon
the commonly use REST specifications found in modern day web based APIs.


### Prerequisites

-  Ruby 1.9.3
-  Sinatra

**NOTE:** Altough this was built using Ruby 1.9.3, you should be able to use with
newer versions of ruby.


**See Gemfile for full list of dependencies**


**NOTE** Although the Gemfile includes the sequel gem, which is used as our ORM
for the database, at this point we are keeping things very simple and are not 
using a database.  It is included in case We implement in the future.


### Install Instructions


1.  Clone the repo to your development workstation/computer

```
cd /path/to/my/projects
git clone xxxx
```


2.  Pull in dependencies using bundler

```
cd api-v2-planning
bundle install
```

Once you have cloned and executed 'bundle install' then you should see a file structure similar to:

```
➜  api-v2-planning tree
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── api_base.rb
└── test
    ├── endpoints
    │   ├── api_v2_hosts_attributes_test.rb
    │   ├── api_v2_hosts_interfaces_test.rb
    │   ├── api_v2_hosts_mounts_test.rb
    │   ├── api_v2_hosts_test.rb
    │   └── api_v2_utility_test.rb
    ├── fixtures
    │   └── json_files
    │       ├── host_minimal.json
    │       ├── host_with_hostname_attrs_minimal.json
    │       ├── host_with_hostname_attrs_minimal_patch.json
    │       ├── host_with_hostname_ifaces_minimal.json
    │       ├── host_with_hostname_ifaces_minimal_patch.json
    │       ├── host_with_hostname_mounts_minimal.json
    │       ├── host_with_hostname_mounts_minimal_patch.json
    │       ├── host_with_id_attrs_minimal.json
    │       ├── host_with_id_attrs_minimal_patch.json
    │       ├── host_with_id_ifaces_minimal.json
    │       ├── host_with_id_ifaces_minimal_patch.json
    │       ├── host_with_id_mounts_minimal.json
    │       └── host_with_id_mounts_minimal_patch.json
    └── test_helper.rb

4 directories, 24 files
➜  api-v2-planning
```



### Running The Test Suite

```
# Running Endpoint test(s)
ruby test/endpoints/[file_name_here].rb
  -OR-
rake test:endpoints

# Examples:
ruby test/endpoints/api_v2_utility_test.rb
ruby test/endpoints/api_v2_hosts_test.rb
ruby test/endpoints/api_v2_hosts_attributes_test.rb


# Running All Tests:
rake test:all
  -OR-
rake test
  -OR-
rake
```

**NOTE:**  There should only be one failing test after you clone and run the 
test suite.  This failing test is intentional - go fix it!


### Running In Your Development Environment

Make sure you are in your project directory.  Then you can run the code and use your browser or Postman to do some manual tests.

```
cd /path/to/project/csi-api-v2-planning
ruby api_base.rb 
```


