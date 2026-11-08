#!/bin/bash
# Proyecto 1 · Despliegue del servidor web de Librería Tinta mediante AWS CLI
set -euo pipefail

export AWS_PAGER=""

REGION="us-east-1"
SUBNET_ID="subnet-01990ffc267c00230"
VPC_ID="vpc-03adedd6142dea0e7"
MI_IP="37.228.235.35/32"
ALUMNO="Aitor Saez"

# 1. AMI más reciente de Amazon Linux 2023
AMI_ID=$(aws ssm get-parameter \
  --region "$REGION" \
  --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --query 'Parameter.Value' \
  --output text)

echo "AMI seleccionada: $AMI_ID"

# 2. Grupo de seguridad
SG_ID=$(aws ec2 create-security-group \
  --region "$REGION" \
  --group-name libreria-web-cli-sg \
  --description "Web Libreria Tinta (CLI)" \
  --vpc-id "$VPC_ID" \
  --query 'GroupId' \
  --output text)

echo "Grupo de seguridad creado: $SG_ID"

aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port 22 \
  --cidr "$MI_IP"

# 3. Instancia EC2
INSTANCE_ID=$(aws ec2 run-instances \
  --region "$REGION" \
  --image-id "$AMI_ID" \
  --instance-type t3.micro \
  --key-name vockey \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids "$SG_ID" \
  --user-data file://user-data1.sh \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=libreria-web-cli},{Key=Proyecto,Value=P1},{Key=Alumno,Value=$ALUMNO}]" \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Instancia creada: $INSTANCE_ID"

# 4. Esperar a que esté ejecutándose y obtener su IP pública
aws ec2 wait instance-running \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID"

IP=$(aws ec2 describe-instances \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "Instancia en ejecución: $INSTANCE_ID"
echo "Abre en el navegador: http://$IP"
