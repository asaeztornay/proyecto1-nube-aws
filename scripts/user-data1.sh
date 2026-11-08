#!/bin/bash
dnf install -y nginx
systemctl enable --now nginx

cat > /usr/share/nginx/html/index.html <<EOF
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Librería Tinta</title>
</head>
<body>
  <h1>Librería Tinta</h1>
  <p>Tu librería de barrio.</p>
  <p><strong>Horario:</strong> lunes a sábado, de 10:00 a 14:00 y de 17:00 a 20:30.</p>
  <p><strong>Dirección:</strong> Calle de la Lectura, 12.</p>
  <p><strong>Recomendación:</strong> <em>El principito</em>, de Antoine de Saint-Exupéry.</p>
  <hr>
  <small>Desplegado por Aitor Saez en el servidor $(hostname) el $(date '+%d/%m/%Y %H:%M')</small>
</body>
</html>
EOF
