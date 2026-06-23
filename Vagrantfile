Vagrant.configure("2") do |config|
  config.vm.box = "bento/rockylinux-10.0"
  config.vm.box_version = "202510.26.0"


  # HTTP
  config.vm.network "forwarded_port", guest: 80, host: 50000

  # HTTPS
  config.vm.network "forwarded_port", guest: 443, host: 50001
  # SSH
  config.vm.network "forwarded_port", guest: 22, host: "60000", auto_correct: true, id: "ssh"

end