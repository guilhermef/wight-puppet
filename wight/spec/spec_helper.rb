require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
root_path = File.expand_path(File.join(__FILE__, '..', '..', '..'))
RSpec.configure do |c|
  c.filter_run :focus => true
  c.run_all_when_everything_filtered = true
  c.module_path = "#{root_path}:#{File.expand_path(File.join(root_path, 'modules'))}"
  c.manifest_dir = File.join(fixture_path, 'manifests')
end

