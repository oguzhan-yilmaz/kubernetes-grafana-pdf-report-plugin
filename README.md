# kubernetes-grafana-pdf-report-plugin
Deploy [mahendrapaipuri/grafana-dashboard-reporter-app](https://github.com/mahendrapaipuri/grafana-dashboard-reporter-app) Grafana Plugin on Kubernetes for kube-prometheus-stack


## Helm Installation

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

```bash
helm show values prometheus-community/kube-prometheus-stack  --version 62.4.0 > grafana-default-values.yaml
```


```bash
curl -O https://raw.githubusercontent.com/oguzhan-yilmaz/kubernetes-grafana-pdf-report-plugin/refs/heads/main/grafana-pdf-report-app.values.yaml
```

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

