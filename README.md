# Portfolio DevOps — Achraf Acheche

Personal portfolio deployed with a full DevOps pipeline on AWS.

🌐 **Live:** http://achraf-acheche.mooo.com
💻 **GitHub:** https://github.com/AchecheAchraf/portfolio-achraf

---

## Stack

| Tool | Role |
|------|------|
| Docker | Containerize the app with Nginx |
| Terraform | Provision AWS infrastructure as code |
| Ansible | Automate server configuration |
| Kubernetes | Container orchestration (minikube + k3s) |
| Jenkins | CI/CD pipeline |
| Prometheus | Metrics collection |
| Grafana | Monitoring dashboard |
| AWS EC2 | Cloud hosting (eu-west-3 Paris) |

---

## Architecture

```
Developer (git push)
        ↓
    GitHub
        ↓
    Jenkins (CI/CD)
        ↓
  Docker Build
        ↓
  Docker Hub
        ↓
  EC2 (AWS Paris)
        ↓
  Portfolio Live
```

---

## Project Structure

```
portfolio/
├── index.html              # Portfolio website
├── images/                 # Assets
├── cv_achraf_acheche.pdf   # CV
├── Dockerfile              # Docker image definition
├── nginx.conf              # Nginx configuration
├── docker-compose.yml      # Local testing
├── Jenkinsfile             # CI/CD pipeline
├── .dockerignore
├── ansible/
│   ├── inventory.ini       # EC2 host
│   └── playbook.yml        # Server configuration
├── terraform/
│   ├── main.tf             # EC2 + Security Group + Key Pair
│   ├── variables.tf        # Variables
│   └── outputs.tf          # Outputs (IP, URL)
└── k8s/
    ├── deployment.yml      # Kubernetes Deployment
    └── service.yml         # Kubernetes Service
```

---

## Phases

### Phase 1 — Docker
Containerized the portfolio using Nginx alpine image.

```bash
docker build -t portfolio:v1 .
docker compose up
```

### Phase 2 — Terraform
Provisioned an EC2 t3.micro instance on AWS Paris with security groups and key pair.

```bash
cd terraform
terraform init
terraform apply
```

### Phase 3 — Ansible
Automated Docker installation and container deployment on the EC2.

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```

### Phase 4 — Kubernetes
Deployed the portfolio on a local Kubernetes cluster using minikube.

```bash
cd k8s
kubectl apply -f deployment.yml
kubectl apply -f service.yml
minikube service portfolio-service --url
```

### Phase 5 — Jenkins CI/CD
Full automated pipeline triggered on every GitHub push:
1. Clone repository
2. Build Docker image
3. Push to Docker Hub
4. Deploy to EC2

### Phase 6 — Prometheus + Grafana
Real-time monitoring of the EC2 server:
- Node Exporter for system metrics
- Prometheus for metrics collection
- Grafana dashboard (Node Exporter Full — ID 1860)

---

## Live URLs

| Service | URL |
|---------|-----|
| Portfolio | http://achraf-acheche.mooo.com |
| Jenkins | http://35.180.214.152:8081 |
| Grafana | http://35.180.214.152:3000 |
| Prometheus | http://35.180.214.152:9090 |

---

## Author

**Achraf Acheche**
[LinkedIn](https://www.linkedin.com/in/achraf-acheche) · [GitHub](https://github.com/AchecheAchraf)
