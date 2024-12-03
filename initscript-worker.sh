
cp -r /vagrant/files/worker-node /srv/salt
salt-call --local state.apply