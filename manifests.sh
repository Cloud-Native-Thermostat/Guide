#!/bin/sh

set -ex

export KUBECONFIG=./tmp/kube_config.yml 

echo "Generate master password to tmp/adminpass"
if [[ ! -e tmp/adminpass ]]; then
  mkdir -p tmp
  echo "adminuser=admin" > tmp/adminpass
  echo "adminpass=$(openssl rand -base64 10)" >> tmp/adminpass
fi

echo "Cleanup manifests folder"
rm -rf  manifests && mkdir manifests

manifests="cert-manager ingress-nginx metallb-system monitoring-system rabbitmq-operator"

for service_namespace in ${manifests}
do
  echo Generate ${service_namespace} manifests
  docker run -it --rm -v ${PWD}:/workdir docker.io/devincan/kustomize:v3.8.4 build --load_restrictor 'LoadRestrictionsNone' --enable_alpha_plugins Sources/${service_namespace} -o manifests/${service_namespace}.yml
  
  echo Apply manifests/${service_namespace}.yml manifests to cluster
  docker run -it --rm -e KUBECONFIG=/workdir/tmp/kube_config.yml -v ${PWD}:/workdir bitnami/kubectl:1.18.8 apply --wait --record=false -f /workdir/manifests/${service_namespace}.yml
done

