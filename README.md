---
---
# Cloud Native Thermostat

This is step by step guide on how to build and maintain cloud native thermostat using Raspberry Pi, K3s on K3os and cheap ESP8266 microchip.

![Raspberry Pi K3os Cluster](./img/Raspberry%20Pi%20K3os%20Cluster.jpeg)

## Why?

Because I hated our bathroom floor heating thermostat and wanted something better and learn new things along the way.

## Why Cloud Native? Isn't it bit overhead?

Running K8s cluster to power simple cron job for triggering heating on and off may seem like overhead 🥴. But in the another way running such a critical application like home heating on some single Raspberry Pi using undocumented scripts, is not good recipe for happy family life 💥. Most importantly Kubernetes is my daily bread and I wanted home project, where I can try new technologies and approaches 🕴

## What

- Manager nodes [Raspberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) 4GB
- OS [K3OS](https://github.com/rancher/k3os) build using [picl-k3os-image-generator](https://github.com/elmariofredo/picl-k3os-image-generator)
- Scheduler [K3s](https://github.com/rancher/k3s)
- Loadbalancer [Metallb](./Sources/metallb-system)
- Ingress [NGINX Ingress Controller](./Sources/ingress-nginx)
- Monitoring 
  - [Grafana](./Sources/monitoring-system/grafana)
  - [Node exporter](./Sources/monitoring-system/node-exporter)
  - [VictoriaMetrics Operator](./Sources/monitoring-system/victoriametrics)

## How does it work?

TODO

## How to start?

Fork and clone this repo https://github.com/elmariofredo/cnt and follow this guide divided into several steps.

1. [Install cluster](./1-Install%20cluster.md)
2. [Install services](./2-Install%20services.md)
3. [Install thermostat services](./) TODO
4. [Build thermostat](./) TODO
