#
# Cookbook:: fileserver
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'fileserver::default' do

  context 'Verification' do

    let(:user)     { 'foo' }
    let(:user_id)  { 1234 }
    let(:group)    { 'bar' }
    let(:group_id) { 5678 }

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.normal['fileserver']['user']          = user
        node.normal['fileserver']['user_id']       = user_id
        node.normal['fileserver']['group']         = group
        node.normal['fileserver']['group_id']      = group_id
        node.normal['fileserver']['configuration'] = {
          'param1' => 10,
          'param2' => [1, 2, 3],
          'param3' => {
            'foo' => 'bar',
            'fiz' => ['b', 'u', 'z', 'z']
          }
        }
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the user' do
      expect(chef_run).to create_user(user)
        .with_uid(user_id)
    end

    it 'creates the group' do
      expect(chef_run).to create_group(group)
        .with_gid(group_id)
    end

    it 'creates the fileserver directory' do
      expect(chef_run).to create_directory('/var/lib/fileserver-Fauxhai')
        .with_owner(user)
        .with_group(group)
    end

    it 'creates the fileserver configuration' do
      expect(chef_run).to create_template('/var/lib/fileserver-Fauxhai/fileserver-config.yaml')
        .with_owner(user)
        .with_group(group)

      expect(chef_run).to render_file('/var/lib/fileserver-Fauxhai/fileserver-config.yaml')
        .with_content("---\nparam1: 10\nparam2:\n- 1\n- 2\n- 3\nparam3:\n  foo: bar\n  fiz:\n  - b\n  - u\n  - z\n  - z")
    end

    it 'notifies fileserver service' do
      expect(chef_run.template('/var/lib/fileserver-Fauxhai/fileserver-config.yaml'))
        .to notify('service[fileserver]').to(:restart)
    end

  end
end
