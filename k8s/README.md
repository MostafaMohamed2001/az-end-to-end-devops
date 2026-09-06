# Apex Kubernetes Manifests

Files:
- namespace.yaml
- secret.yaml
- deployment.yaml
- service.yaml
- hpa.yaml
- pdb.yaml

## Important
Edit `secret.yaml` and replace `CHANGE_ME` with the real PostgreSQL password.

Do not commit the real password to Git.

For a proper production setup, use Azure Key Vault / External Secrets instead of storing the secret value in Git.

## Apply
```bash
kubectl apply -f namespace.yaml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
kubectl apply -f pdb.yaml
```

Or:
```bash
kubectl apply -f .
```

## Check
```bash
kubectl get all -n apex
kubectl get pods -n apex
kubectl logs -n apex deployment/apex-app
kubectl get svc -n apex
```

## Notes
The Service is type LoadBalancer so Azure will create a public IP for testing.

HPA requires Metrics Server. AKS usually provides resource metrics support, but verify with:
```bash
kubectl top pods -n apex
```
