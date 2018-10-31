
docker run -d \
  --name k8s_ha \
  -p 6443:6443 \
  -v /etc/haproxy:/usr/local/etc/haproxy:ro \
  haproxy:1.8

