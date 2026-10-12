# node-app

A simple Node.js 20 + Express service, packaged to run on its own in Kubernetes.

## Endpoints

| Endpoint | Purpose |
|---|---|
| `GET /` | JSON with app name, stack, version and pod hostname |
| `GET /health` | Liveness probe |
| `GET /ready` | Readiness probe |

Container port: **3000**

## Files

```
node-app/
├── server.js
├── package.json
├── Dockerfile
├── deploy.sh
└── k8s/
    ├── namespace.yaml     # namespace: node-app
    ├── deployment.yaml    # 2 replicas, probes, limits, non root
    └── service.yaml       # ClusterIP, port 80 -> 3000
```

## Run locally

```bash
npm install
npm start
curl localhost:3000/
```

## Deploy with the script

```bash
./deploy.sh <your-registry>            # tag defaults to 1.0.0
./deploy.sh <your-registry> 1.0.1      # new version
```

## Deploy manually

```bash
docker build -t <your-registry>/node-app:1.0.0 .
docker push <your-registry>/node-app:1.0.0

# set the image in k8s/deployment.yaml, then:
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/
kubectl -n node-app get pods,svc
```

### kind or minikube (no registry)

```bash
docker build -t your-registry/node-app:1.0.0 .
kind load docker-image your-registry/node-app:1.0.0        # or: minikube image load your-registry/node-app:1.0.0
kubectl apply -f k8s/namespace.yaml && kubectl apply -f k8s/
```

## Test

```bash
kubectl -n node-app port-forward svc/node-app 8080:80
curl localhost:8080/
```

## Scale or remove

```bash
kubectl -n node-app scale deploy/node-app --replicas=4
kubectl delete namespace node-app
```
