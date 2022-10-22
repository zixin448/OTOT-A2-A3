# ======================
echo "demo for task A2"

echo $line
# ======================
# ======================
echo "Setting Up"

echo $line
# ======================

echo "Creating cluster"
kind create cluster --name kind-1 --config k8s/kind/cluster-config.yaml

echo $line

echo "Applying backend-deployment"
kubectl apply -f k8s/manifests/backend-deployment.yaml

echo $line

echo "Labelling the nodes as Ingress-ready"
kubectl label node kind-1-control-plane ingress-ready=true
kubectl label node kind-1-worker ingress-ready=true
kubectl label node kind-1-worker2 ingress-ready=true
kubectl label node kind-1-worker3 ingress-ready=true

echo $line

echo "Applying ingress controller"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo $line

echo "Apply backend-service"
kubectl apply -f k8s/manifests/backend-service.yaml

echo $line

echo "Applying backend-ingress"
kubectl apply -f k8s/manifests/backend-ingress.yaml

echo $line

# ======================
echo "Verifying..."

echo $line
# ======================

echo "Check docker"
docker ps

echo $line

echo "Inspecting node containers"
kubectl get nodes

echo $line

echo "Check cluster info"
kubectl cluster-info

echo $line

echo "Waiting for backend deployment"
kubectl rollout status deployment/backend

echo $line

echo "Verifying Deployment"
kubectl get deployment.apps/backend

echo $line

echo "Verifying individual containers"
kubectl get po -l app=backend --watch

echo $line

echo "Verifying labelling of ingress-ready"
kubectl get nodes -L ingress-ready --watch

echo $line

echo "Waiting for Ingress controller Deployment"
kubectl -n ingress-nginx rollout status deploy --watch

echo $line

echo "Check progress of deployment of ingress controller"
kubectl -n ingress-nginx get deploy

echo $line

echo "Verifying Service"
kubectl get svc -l app=backend

echo $line

echo "Describing backend-svc"
kubectl describe svc backend-svc

echo $line

kubectl port-forward service/backend-svc 8080:8080

echo $line

echo "Verifying ingress"
kubectl get ingress -l app=backend