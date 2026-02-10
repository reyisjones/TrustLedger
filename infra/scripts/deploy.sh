#!/bin/bash

# TrustLedger Deployment Script

set -e

echo "🚀 Starting TrustLedger deployment..."

# Check prerequisites
command -v terraform >/dev/null 2>&1 || { echo "❌ Terraform is required but not installed. Aborting."; exit 1; }
command -v helm >/dev/null 2>&1 || { echo "❌ Helm is required but not installed. Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl is required but not installed. Aborting."; exit 1; }

# Azure login (assumes az CLI is configured)
echo "🔐 Logging into Azure..."
az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID

# Deploy infrastructure
echo "🏗️  Deploying infrastructure with Terraform..."
cd infra/terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Get outputs
API_URL=$(terraform output -raw api_gateway_url)
KEY_VAULT_URL=$(terraform output -raw key_vault_url)

cd ../..

# Deploy to Kubernetes
echo "⚓ Deploying to Kubernetes with Helm..."
helm upgrade --install trustledger infra/helm \
  --set apiGateway.env[1].value=$KEY_VAULT_URL \
  --set ingress.hosts[0].host=$API_URL \
  --wait

# Run database migrations
echo "🗄️  Running database migrations..."
kubectl exec -it $(kubectl get pods -l app.kubernetes.io/name=trustledger-postgresql -o jsonpath='{.items[0].metadata.name}') -- psql -U postgres -d trustledger -f /docker-entrypoint-initdb.d/init.sql

# Health check
echo "🏥 Running health checks..."
sleep 30
curl -f $API_URL/health || { echo "❌ API health check failed"; exit 1; }

echo "✅ TrustLedger deployment completed successfully!"
echo "🌐 API Gateway: $API_URL"
echo "🔑 Key Vault: $KEY_VAULT_URL"