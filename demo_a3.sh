# ======================
echo "demo for task A3"

echo $line
# ======================
# ======================
echo "Setting Up"

echo $line
# ======================

echo "Installing metrics-servers"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo $line

echo "Edit the TLF Deployment manifest and add a flag `--kubelet-insecure-tls` to `deployment.spec.containers[].args[]`"
kubectl -nkube-system edit deploy/metrics-server

echo $line

echo "Restarting the TLF Deloyment"
kubectl -nkube-system rollout restart deploy/metrics-server

echo $line

echo "Applying Horizontal Pod Autoscaler"
kubectl apply -f k8s/manifests/backend-horizontalpodautoscaler.yaml

echo $line

echo "Applying backend-zone-aware"
kubectl apply -f k8s/manifests/backend-zone-aware.yaml

echo $line

# ======================
echo "Verifying..."

echo $line
# ======================
kubectl get po

echo $line

echo "Viewing nodes"
kubectl get nodes -L topology.kubernetes.io/zone

echo $line

echo "Verifying backend-zone-aware"
kubectl get po -lapp=backend-zone-aware -owide --sort-by='.spec.nodeName'

echo $line

echo "See current hpa"
kubectl describe hpa

echo $line

echo "Run `kubectl describe hpa` while refreshing page to verify scale up"
