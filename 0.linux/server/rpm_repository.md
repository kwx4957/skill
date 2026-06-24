## RPM Repositry

### 서버

```bash
dnf install -y dnf-plugins-core createrepo nginx

mkdir -p /data/repos/rocky/10
cd /data/repos/rocky/10

dnf repolist

dnf reposync --repoid=baseos    --download-metadata -p /data/repos/rocky/10
du -sh /data/repos/rocky/10/baseos/
ls -l /data/repos/rocky/10/baseos/repodata/
cat /data/repos/rocky/10/baseos/repodata/repomd.xml 
dnf reposync --repoid=appstream --download-metadata -p /data/repos/rocky/10
du -sh /data/repos/rocky/10/appstream/
dnf reposync --repoid=extras    --download-metadata -p /data/repos/rocky/10
du -sh /data/repos/rocky/10/extras/

cat <<EOF > /etc/nginx/conf.d/repos.conf
server {
    listen 80;
    server_name repo-server;

    location /rocky/10/ {
        autoindex on;                 
        autoindex_exact_size off;     
        autoindex_localtime on;       
        root /data/repos;
    }
}
EOF

# nginx 시작 
systemctl enable --now nginx
systemctl status nginx.service --no-pager
ss -tnlp | grep nginx
```

### 클라이언트

```bash
cat <<EOF > /etc/yum.repos.d/internal-rocky.repo
[internal-baseos]
name=Internal Rocky 10 BaseOS
baseurl=http://192.168.10.10/rocky/10/baseos
enabled=1
gpgcheck=0

[internal-appstream]
name=Internal Rocky 10 AppStream
baseurl=http://192.168.10.10/rocky/10/appstream
enabled=1
gpgcheck=0

[internal-extras]
name=Internal Rocky 10 Extras
baseurl=http://192.168.10.10/rocky/10/extras
enabled=1
gpgcheck=0
EOF

dnf clean all
dnf repolist
dnf makecache
```