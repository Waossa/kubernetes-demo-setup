
sed -i '/swap/s/^/# /' /etc/fstab
#sudo systemctl mask  "dev-*.swap"