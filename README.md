# kubernetes-grafana-pdf-report-plugin

Deploy [mahendrapaipuri/grafana-dashboard-reporter-app](https://github.com/mahendrapaipuri/grafana-dashboard-reporter-app) Grafana Plugin on Kubernetes for kube-prometheus-stack

## Why use this?

All configuration is made through the kube-prometheus-stack's values.yaml, giving you simple way to manage the whole installation.

I've had such configuration hell setting this up it was a nightmare. This is the working configuration, happy to share it.


## Helm Installation

Add the helm repository.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update prometheus-community
```

Get the default values for [kube-prometheus-stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

```bash
helm show values prometheus-community/kube-prometheus-stack > grafana-default-values.yaml
```

Get the grafana reporter plugin values from this repo.
```bash
curl -O https://raw.githubusercontent.com/oguzhan-yilmaz/kubernetes-grafana-pdf-report-plugin/refs/heads/main/grafana-pdf-report-app.values.yaml
```

Run Helm install command with a seconday values.yaml.

```bash
RELEASE_NAME="kube-prometheus-stack"
NAMESPACE="monitoring"
VERSION="62.4.0"

helm upgrade --install "$RELEASE_NAME" -n "$NAMESPACE" \
        -f grafana-default-values.yaml \
        -f grafana-pdf-report-app.values.yaml \
        --version "$VERSION" \
    prometheus-community/kube-prometheus-stack
```

## Next Steps

Follow the [mahendrapaipuri/grafana-dashboard-reporter-app](https://github.com/mahendrapaipuri/grafana-dashboard-reporter-app) documentation to learn about 

- how to setup Grafana UI button to generate pdf reports
- which endpoints are published so you can use them programmatically as well
- fine-tune values.yaml resources and HPA autoscaling
