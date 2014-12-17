require 'spec_helper'



describe 'nfs' do
  context "server => true" do
    let(:params) {{ :server_enabled => true }}
    let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
    it do
      should contain_concat__fragment('nfs_exports_header').with( 'target' => '/etc/exports' )
    end
    context "nfs_v4 => true" do
      let(:params) { {:nfs_v4 => true, :server_enabled => true } }
      it { should contain_concat__fragment('nfs_exports_root').with( 'target' => '/etc/exports' ) }
      it { should contain_file('/export').with( 'ensure' => 'directory' ) }
    end

    context "operatingsysten => ubuntu" do
      let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_package('nfs-kernel-server')
        should contain_service('nfs-kernel-server').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring'  }}
        it { should contain_service('idmapd').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context "operatingsysten => debian" do
      let(:facts) { {:operatingsystem => 'debian', :concat_basedir => '/tmp',} }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_package('nfs-kernel-server')
        should contain_service('nfs-kernel-server').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring'  }}
        it { should contain_service('idmapd').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context "operatingsysten => redhat" do
      let(:facts) { {:operatingsystem => 'redhat', :concat_basedir => '/tmp',} }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring' }}
        it { should contain_service('idmapd').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
    context "operatingsysten => gentoo" do
      let(:facts) { {:operatingsystem => 'gentoo', :concat_basedir => '/tmp',} }
      it { should contain_class('nfs::server::config') }
      it { should contain_class('nfs::server::package') }
      it { should contain_class('nfs::server::service') }
      it do
        should contain_service('nfs').with( 'ensure' => 'running'  )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :server_enabled => true, :nfs_v4_idmap_domain => 'teststring' }}
        it { should contain_service('rpc.idmapd').with( 'ensure' => 'running'  ) }
        it { should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/) }
      end
    end
  end
  context "client => true" do
    context "operatingsysten => ubuntu" do
      let(:params) {{ :client_enabled => true, :server_enabled => false  }}
      let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it do
        should contain_service('portmap').with(
          'ensure' => 'running'
        )
        should contain_package('nfs-common')
        should contain_package('nfs4-acl-tools')
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :client_enabled => true }}
        it do
          should contain_augeas('/etc/default/nfs-common')
          should contain_augeas('/etc/idmapd.conf')
          should contain_service('rpcbind').with(
            'ensure' => 'running'
          )
          should contain_service('nfs-lock').with(
            'ensure' => 'running'
          )
        end
      end
    end
    context "operatingsysten => debian" do
      let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it do
        should contain_package('nfs-common')
        should contain_package('nfs4-acl-tools')
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :client_enabled => true }}
        it do
          should contain_augeas('/etc/default/nfs-common')
          should contain_augeas('/etc/idmapd.conf')
          should contain_service('rpcbind').with(
            'ensure' => 'running'
          )
          should contain_service('nfs-lock').with(
            'ensure' => 'running'
          )
        end
      end
    end
    context "operatingsysten => redhat" do
      let(:facts) { {:operatingsystem => 'redhat', :concat_basedir => '/tmp', } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it do
        should contain_service('nfslock').with(
          'ensure' => 'running'
        )
        should contain_package('nfs-utils')
        should contain_package('nfs4-acl-tools')
        should contain_package('rpcbind')
        should contain_service('rpcbind').with(
          'ensure' => 'running'
        )
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :client_enabled => true }}
        it do
          should contain_augeas('/etc/default/nfs-common')
          should contain_augeas('/etc/idmapd.conf')
          should contain_service('rpcbind').with(
            'ensure' => 'running'
          )
          should contain_service('idmapd').with(
            'ensure' => 'running'
          )
        end
      end
    end
    context "operatingsysten => gentoo" do
      let(:facts) { {:operatingsystem => 'gentoo', :concat_basedir => '/tmp',  :client_enabled => true } }
      it { should contain_class('nfs::client::config') }
      it { should contain_class('nfs::client::package') }
      it { should contain_class('nfs::client::service') }
      it do
        should contain_package('net-nds/rpcbind')
        should contain_package('net-fs/nfs-utils')
        should contain_package('net-libs/libnfsidmap')
      end
      context ":nfs_v4 => true" do
        let(:params) {{ :nfs_v4 => true, :client_enabled => true }}
        it do
          should contain_augeas('/etc/conf.d/nfs')
          should contain_augeas('/etc/idmapd.conf')
          should contain_service('rpcbind').with(
            'ensure' => 'running'
          )
          should contain_service('rpc.idmapd').with(
            'ensure' => 'running'
          )
        end
      end
    end
  end
  context "operatingsysten => gentoo" do
    let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
    let(:params) { { :nfs_v4 => true, :client_enabled => true, } }
    it { should contain_class('nfs::client::config') }
    it { should contain_class('nfs::client::package') }
    it { should contain_class('nfs::client::service') }
  end
end