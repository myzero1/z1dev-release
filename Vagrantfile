# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
# ---------------------- 检查vagrant插件 ----------------------
# https://cloud.tencent.com/developer/ask/sof/115189
# https://github.com/zepgram/magento2-fast-vm/blob/master/Vagrantfile
# if OS.is_windows
if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  # required_plugins = %w(vagrant-share vagrant-vbguest)
  required_plugins = %w(vagrant-winnfsd)

  begin
      plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
      if not plugins_to_install.empty?
          puts "Installing plugins: #{plugins_to_install.join(' ')}"
          # vagrant plugin install vagrant-winnfsd  --plugin-version 1.4.0 --plugin-clean-sources --plugin-source https://gems.ruby-china.com/
          # if system "vagrant plugin install #{plugins_to_install.join(' ')}"
          if system "vagrant plugin install --plugin-clean-sources --plugin-source https://gems.ruby-china.com/ #{plugins_to_install.join(' ')}"
              exec "vagrant #{ARGV.join(' ')}"
          else
              abort "Installation of one or more plugins has failed. Aborting."
          end
      end
  rescue
      exec "vagrant #{ARGV.join(' ')}"
  end
end
# ---------------------- vagrant的vagrantfile的配置说明 ----------------------
# http://www.hangdaowangluo.com/archives/901
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # 设置virtualbox的默认虚拟电脑位置  virtualbox》管理》全局设定》默认虚拟电脑位置

  # https://www.jianshu.com/p/b18ea9fdf2f3
  # common comand
  # #初始化镜像
  # vagrant init centos7 https://mirrors.ustc.edu.cn/centos-cloud/centos/7/vagrant/x86_64/images/CentOS-7.box
  # #启动镜像
  # vagrant up
  # #连接虚拟机
  # vagrant ssh
  # #销毁虚拟机
  # vagrant destroy
  # #切换root 用户，就不需要每次加 sudo
  # su root                               
  # #默认密码是
  # vagrant
  # #查看当前用户
  # whoami
  # #查看 ip
  # ip add
  # #登录后切换root用户，这样才能看到  /etc/ssh/sshd_config 文件
  # sudo -i
  # #修改密码，比如 root
  # passwd
  # vagrant snapshot --help
  # vagrant ssh > su root > vagrant # 登录到虚拟机并切换到root用户

  # https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cloud-images/bionic/current/bionic-server-cloudimg-amd64-vagrant.box
  # https://mirrors.ustc.edu.cn/centos-cloud/centos/7/vagrant/x86_64/images/CentOS-7.box
  # 这个box的os使用的是国内镜像
  config.vm.box_url = "https://mirrors.ustc.edu.cn/centos-cloud/centos/7/vagrant/x86_64/images/CentOS-7.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "private_network", type: "dhcp"
  config.vm.network "private_network", ip: "192.168.56.135"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # https://github.com/gael-ian/vagrant-bindfs
  # https://qa.1r1g.com/sf/ask/1665894891/
  #config.vm.synced_folder "./", "/vagrant-nfs", type: "nfs"
  #config.bindfs.bind_folder "/vagrant-nfs", "/wk"

  # https://qa.1r1g.com/sf/ask/1665894891/
  config.vm.synced_folder ".", "/vagrant", :disabled => true
  config.vm.synced_folder "./workspace", "/workspace", :nfs => true
  # config.vm.synced_folder "./workspace", "/nfs-workspace", :nfs => true
  # config.bindfs.bind_folder "/nfs-workspace", "/workspace", after: :provision
  # config.bindfs.bind_folder "/nfs-workspace", "/workspace", after: :provision
  # :'create-with-perms' => "u=rwX:g=rD:o=rD",
  # config.bindfs.bind_folder "/nfs-workspace", "/workspace", after: :provision,
  # :owner => "mysql",
  # :group => "mysql",
  # :perms => "u=rwx:g=rwx:o=rwx",
  # :'create-as-user' => true,
  # :'create-with-perms' => "u=rwx:g=rwx:o=rwx",
  # :'chown-ignore' => false, 
  # :'chgrp-ignore' => false, 
  # :'chmod-ignore' => false

  # # config.bindfs.force_empty_mountpoints = true
  # config.vm.synced_folder "./workspace/projects/default/workspace-pub/data/mysql", "/nfs-workspace/projects/default/workspace-pub/data/mysql", :nfs => true, :create => true
  # config.bindfs.bind_folder "/nfs-workspace/projects/default/workspace-pub/data/mysql", "/workspace/projects/default/workspace-pub/data/mysql", after: :provision,
  # :owner => "mysql",
  # :group => "mysql",
  # :'create-as-user' => true,
  # :'chown-ignore' => false, 
  # :'chgrp-ignore' => false, 
  # :'chmod-ignore' => false
  

  # config.bindfs.bind_folder "/var/lib/mysql/#{wp_db}", "/var/lib/mysql/#{wp_db}", u: 'mysql', g: 'mysql', p: 'og-x:og+rD:u=rwX:g+rw', after: 'provision'

  # -------------- 让Vagrant在Windwos下支持使用NFS/SMB共享文件夹从而解决目录共享IO缓慢的问题 --------------------
  # https://www.cnblogs.com/Basu/p/7853712.html
  # https://www.cnblogs.com/vishun/archive/2017/06/02/6932454.html
  # https://blog.ipsfan.com/5650.html

  # config.vm.synced_folder "./projects", "/vagrant", type: "nfs"

  # vagrant plugin install vagrant-winnfsd
  #winfsd
  # config.winnfsd.logging = "on"
  # config.winnfsd.uid = 1
  # config.winnfsd.gid = 1
  # config.winnfsd.uid = 0
  # config.winnfsd.gid = 0
  # config.nfs.map_uid = 0 #这个是虚拟机里的用户id，比如www是1002,root为0,vagrant为1000,使用"id 用户"名查看
  # config.nfs.map_gid = 0

  # Vagrant 开启 smb 文件共享
  # https://learnku.com/articles/37082
  # onfig.vm.synced_folder "./","/vagrant",
  # type:"smb",
  # smb_host:"192.168.56.1",#windows主机IP
  # smb_username:"username",#windows主机用户名
  # smb_password:"secret",#windows主机密码
  # owner:"www",
  # group:"www",
  # mount_options:["username=username","password=secret"]


  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
    vb.gui = false
  
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    # v.memory = 2048

    vb.cpus = 2
    # vb.name = "z1workspace"
  end
  
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.provision "shell", inline: <<-SHELL
    systemctl stop firewalld
    yum install iptables-services -y
    systemctl enable iptables
    systemctl start iptables

    groupadd mysql && useradd -r -g mysql mysql

    # https://blog.csdn.net/zhangjunli/article/details/108253281
    rm -rf /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    vim /etc/sysconfig/clock
    ZONE="Asia/Shanghai"
    UTC=false
    ARC=false
    yum install -y ntp
    systemctl start ntpd
    systemctl enable ntpd
    echo '/usr/sbin/ntpdate ntp1.aliyun.com > /dev/null 2>&1; /sbin/hwclock -w' >> /etc/rc.d/rc.local
    chomd +x /etc/rc.d/rc.local

    # crontab -e
    # 0 */1 * * * ntpdate ntp1.aliyun.com > /dev/null 2>&1; /sbin/hwclock -w

    echo '0 */1 * * * ntpdate ntp1.aliyun.com > /dev/null 2>&1; /sbin/hwclock -w' >> /var/spool/cron/root
    echo '0 */1 * * * ntpdate ntp1.aliyun.com > /dev/null 2>&1; /sbin/hwclock -w' >> /var/spool/cron/vagrant
    service crond restart

    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
    systemctl restart sshd

  SHELL

end
