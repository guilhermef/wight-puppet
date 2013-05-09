require 'spec_helper'

shared_context "common configuration" do |params|
  let(:params) {params}
  params = {} unless params

  let(:conf_path) { params[:conf_path] || "/etc/#{title}" }
  let(:conf_file) { params[:conf_file] || "#{title}.conf" }
  let(:user) {params[:user] || "root"}
  let(:group) {params[:group] || "root"}
  let(:config_params) {params[:config_params] || {'NUMBER_OF_FORKS' => 4}}
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

describe "wight" do
  let(:title) {'my-wight'}
  let(:facts) {{processorcount: 4}}

  context "configure" do
    it_behaves_like "a config file"
    it_behaves_like "a config file", {conf_path: '/my/amazing/path'}
    it_behaves_like "a config file", {conf_file: 'awesome.conf'}
    it_behaves_like "a config file", {config_params: {'redis_port' => '7080'}}
  end

end
