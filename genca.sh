#!/bin/sh

CERT_DIR='certs'
mkdir -p $CERT_DIR

if [ ! -f $CERT_DIR/ca.pem ]; then
  echo "\nGenerating CA\n"
  openssl genrsa -out $CERT_DIR/ca-key.pem 2048
  openssl req -x509 -new -nodes -key $CERT_DIR/ca-key.pem -days 10000 -out $CERT_DIR/ca.pem -subj "/CN=kube-ca"
fi

if [ ! -f ansible/roles/common/files/etc/kubernetes/ssl/ca.pem ]; then
  echo "Copying CA files to ansible file directory"
  cp -v $CERT_DIR/ca*pem ansible/roles/common/files/etc/kubernetes/ssl/
fi

if [ ! -f $CERT_DIR/admin/admin.pem ]; then
  echo "\nGenerating admin certs\n"
  mkdir -p $CERT_DIR/admin
  openssl genrsa -out $CERT_DIR/admin/admin-key.pem 2048
  openssl req -new -key $CERT_DIR/admin/admin-key.pem -out $CERT_DIR/admin/admin.csr -subj "/CN=kube-admin"
  openssl x509 -req -in $CERT_DIR/admin/admin.csr -CA $CERT_DIR/ca.pem -CAkey $CERT_DIR/ca-key.pem -CAcreateserial -out $CERT_DIR/admin/admin.pem -days 365
fi
