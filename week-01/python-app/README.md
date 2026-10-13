# python-app — Real Estate Landing Page

A faithful single-page replica of a real-estate template (Carrd-style) built
with plain HTML/CSS/JS and served by a tiny Python 3.12 + Flask backend.
Packaged to run on its own in Kubernetes.

## The page (`/`)

Single-page landing with smooth scrolling: **Nav → Hero → About → Stats →
Featured Properties → Inquire → Services → Client Reviews → Team → Contact →
Footer**. Includes:

- `Gloock` + `Inter` Google Fonts, dark `#333` / gold `#B89A52` palette
- Full-bleed photo hero + CTA bands with parallax and dark overlays
- Scroll-reveal animations (fade / zoom / blur / slide, staggered)
- Responsive layout with a mobile nav menu
- Image hover zoom, back-to-top button, social links

Content and imagery mirror the reference template (REAL ESTATE agency demo).

## Probes

| Endpoint | Purpose |
|---|---|
| `GET /` | Landing page |
| `GET /health` | Liveness probe |
| `GET /ready` | Readiness probe |
| `GET /info` | JSON with app name, stack, version, hostname |

Container port: **5000**

## Files

```
python-app/
├── app.py                  # Flask server (sitemap + probes)
├── static/
│   └── index.html          # the landing page
│   └── assets/images/      # photos and icons used by the page
├── requirements.txt
├── Dockerfile
├── deploy.sh
└── k8s/
    ├── namespace.yaml     # namespace: python-app
    ├── deployment.yaml    # 2 replicas, probes, limits, non root
    └── service.yaml       # ClusterIP, port 80 -> 5000
```

## Run locally

```bash
pip install -r requirements.txt
python app.py
# open http://localhost:5000/
```

## Deploy with the script

```bash
./deploy.sh <your-registry>            # tag defaults to 1.0.0
./deploy.sh <your-registry> 1.0.1      # new version
```

## Deploy manually

```bash
docker build -t <your-registry>/python-app:1.0.0 .
docker push <your-registry>/python-app:1.0.0

# set the image in k8s/deployment.yaml, then:
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/
kubectl -n python-app get pods,svc
```

### kind or minikube (no registry)

```bash
docker build -t your-registry/python-app:1.0.0 .
kind load docker-image your-registry/python-app:1.0.0        # or: minikube image load your-registry/python-app:1.0.0
kubectl apply -f k8s/namespace.yaml && kubectl apply -f k8s/
```

## Test

```bash
kubectl -n python-app port-forward svc/python-app 8080:80
curl localhost:8080/
```

## Scale or remove

```bash
kubectl -n python-app scale deploy/python-app --replicas=4
kubectl delete namespace python-app
```