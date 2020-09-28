# Install services

All services are setup using [Kustomize](https://github.com/kubernetes-sigs/kustomize) defined in [Sources](https://github.com/Cloud-Native-Thermostat/Guide/blob/master/Sources) folder. Go ahead and browse this folder to get familiar what is going to be installed on your cluster.

## Deploy

1. Update values in
   1. Change domain in [grafana-chart-values.yml](https://github.com/Cloud-Native-Thermostat/Guide/blob/master/Sources/monitoring-system/grafana/grafana-chart-values.yml)
   2. Add digitalocean.com DNS token to `../tmp/dnstoken`
        access-token=YOUR_TOKEN
      If you use different DNS provider change [issuer.yml](https://github.com/Cloud-Native-Thermostat/Guide/blob/master/Sources/cert-manager/issuer.yml) see [docs](http://www.nodemcu.com/index_en.html) for more informations.
   3. Change loadbalancer IP in [metallb](https://github.com/Cloud-Native-Thermostat/Guide/blob/master/Sources/metallb-system/configs/config) and then also in ingress [controller](https://github.com/Cloud-Native-Thermostat/Guide/blob/master/Sources/ingress-nginx/kustomization.yml)
   4. Change email in [cert-manager](https://github.com/Cloud-Native-Thermostat/Guide/blob/master/Sources/cert-manager/issuer.yml)
2. Run [manifests.sh](https://github.com/Cloud-Native-Thermostat/Guide/blob/master/manifests.sh) file. In case that you will run into CRD nonexistent error run command again.

## Verify

Log into your grafana dashboard using `./tmp/adminpass` credentials. After login you should see 'Pi k3s Simple Dashboard', look around there are few other dashboard preinstalled for you 😉.
