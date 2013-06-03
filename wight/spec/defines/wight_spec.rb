require 'spec_helper'

shared_context "common configuration" do |params|
  let(:params) {params}
  params = {} unless params

  let(:conf_path) { params[:conf_path] || "/etc/#{title}" }
  let(:conf_file) { params[:conf_file] || "#{title}.conf" }
  let(:user) {params[:user] || "root"}
  let(:group) {params[:group] || "root"}
  let(:config_params) {params[:config_params] || {'NUMBER_OF_FORKS' => 4}}
  let(:wight_version) {params[:wight_version] || 'latest'}
  let(:wight_type) {params[:wight_type] || 'api'}
end

shared_examples "a config file" do |params|
  include_context "common configuration", params

  it {
    should contain_file(conf_path).with(
      ensure: :directory,
      owner: user,
      group: group,
    )
  }

  it {
    should contain_file("#{conf_path}/#{conf_file}").with(
      owner: user,
      group: group,
      content: config_params.inject(''){|file, p| "#{p[0].upcase} = #{p[1]}"} + "\n",
      require: "File[#{conf_path}]"
    )
  }
end

shared_examples "a package" do |params|
  include_context "common configuration", params

  it {
    should contain_package("wight").with(
      provider: 'pip',
      ensure: wight_version
    )
  }
end

shared_examples "a service" do |params|
  include_context "common configuration", params

  it {
    should contain_supervisor__service(title).with(
      ensure: 'present',
      enable: true,
      command: "wight-#{wight_type} -c #{conf_path}/#{conf_file}",
      environment: 'LD_LIBRARY_PATH=/usr/local/lib',
      user: user,
      group: group,
      require: ["File[#{conf_path}/#{conf_file}]", "Package[wight]", "Class[Wight::Libgit]"]
    )
  }
end

shared_examples "a dependency" do |params|
  include_context "common configuration", params

  it {
    should include_class('wight::libgit')
  }
end

describe "wight" do
  let(:title) {'my-wight'}
  let(:facts) {{processorcount: 4, osfamily: "debian"}}

  context "configure" do
    it_behaves_like "a config file"
    it_behaves_like "a config file", {conf_path: '/my/amazing/path'}
    it_behaves_like "a config file", {conf_file: 'awesome.conf'}
    it_behaves_like "a config file", {config_params: {'redis_port' => '7080'}}
  end

  context "package" do
    it_behaves_like "a package"
    it_behaves_like "a package", {wight_version: '1.0.2'}
  end

  context "service" do
    it_behaves_like "a service"
    it_behaves_like "a service", {wight_type: 'web'}
    it_behaves_like "a service", {wight_type: 'worker'}
    it_behaves_like "a service", {wight_type: 'api'}
  end

  context "dependencies" do
    it_behaves_like "a dependency"
  end

end
