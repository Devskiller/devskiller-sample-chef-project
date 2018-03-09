#
# Cookbook:: fileserver
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'fileserver::default' do
  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the user' do
      expect(chef_run).to create_user('nobody')
        .with_uid(9000)
    end

    it 'creates the group' do
      expect(chef_run).to create_group('nobody')
        .with_gid(9000)
    end

    it 'creates the fileserver directory' do
      expect(chef_run).to create_directory('/var/lib/fileserver-Fauxhai')
        .with_owner('nobody')
        .with_group('nobody')
    end

    it 'creates the fileserver configuration' do
      expect(chef_run).to create_template('/var/lib/fileserver-Fauxhai/fileserver-config.yaml')
        .with_owner('nobody')
        .with_group('nobody')
    end
  end
end
