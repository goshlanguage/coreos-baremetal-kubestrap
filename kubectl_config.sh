#!/bin/bash

CA_DIR="ansible/roles/common/files/etc/kubernetes/ssl"
ADMIN_CERT_DIR=~/.kube/ssl

if [ -z ${MASTER_HOST} ]; then
  read -p "Master Host: " MASTER_HOST;
fi;

if [ ! -f ${ADMIN_CERT_DIR} ]; then
  echo "\nMaking directory ${ADMIN_CERT_DIR}\n"
  mkdir -v ${ADMIN_CERT_DIR};

  openssl genrsa -out ${ADMIN_CERT_DIR}/admin-key.pem 2048
  openssl req -new \
    -key ${ADMIN_CERT_DIR}/admin-key.pem \
    -out ${ADMIN_CERT_DIR}/admin.csr \
    -subj "/CN=kube-admin"

  openssl x509 -req \
  -in ${ADMIN_CERT_DIR}/admin.csr \
  -CA ${CA_DIR}/ca.pem \
  -CAkey ${CA_DIR}/ca-key.pem \
  -CAcreateserial \
  -out ${ADMIN_CERT_DIR}/admin.pem \
  -days 365
fi;

kubectl config set-cluster default-cluster \
  --server=https://${MASTER_HOST} \
  --certificate-authority=${CA_DIR}/ca.pem

kubectl config set-credentials default-admin \
  --certificate-authority=${CA_DIR}/ca.pem \
  --client-key=${ADMIN_CERT_DIR}/admin-key.pem \
  --client-certificate=${ADMIN_CERT_DIR}/admin.pem

kubectl config set-context default-system \
  --cluster=default-cluster \
  --user=default-admin

kubectl config use-context default-system
