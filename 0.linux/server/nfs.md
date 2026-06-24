## NFS 

서버의 리소스를 클라이언트 상에서 마치 자신의 리소스를 사용하는 것처럼 사용할수 있도록 제공한다. 즉, 네트워크가 가능한 곳이라면 리눅스등의 운영체제에서 NFS를 사용하여 파일 시스템 공유가 가능하다. SMB는 445 포트를 사용하며 윈도우의 파일 및 프린트 공유 서비스이다. 

```bash
sudo dnf install -y nfs-utils
sudo systemctl enable --now nfs-server rpcbind
sudo firewall-cmd --add-service={nfs,nfs3,mountd,rpc-bind} --permanent 
sudo firewall-cmd --reload

# Server
mkdir /share
chmod 777 /share
vi /etc/exports
/share 192.168.1.0/24(rw,sync,all_squash)

# nfs 모니터링
exportfs -v
showmount -e

# Client
mkdir -p /mnt/nfs
showmount –e 192.168.1.200
mount -t nfs 192.168.1.200:/share /mnt/nfs

vi /etc/fstab
192.168.1.200:/share /mnt/nfs nfs defaults 0 0 

df
```

https://docs.rockylinux.org/guides/file_sharing/nfsserver/