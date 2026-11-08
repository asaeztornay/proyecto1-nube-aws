#!/bin/bash
dnf install -y nginx
systemctl enable --now nginx

cat > /usr/share/nginx/html/index.html <<EOF
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Librería Tinta - Servidor 2</title>
</head>
<body>
  <h1>Librería Tinta - Servidor 2</h1>
  <p>Segunda versión de la web para probar el DNS ponderado.</p>
  <p><strong>Horario:</strong> lunes a sábado, de 10:00 a 14:00 y de 17:00 a 20:30.</p>
  <p><strong>Dirección:</strong> Calle de la Lectura, 12.</p>
  <p><strong>Recomendación:</strong> <em>El nombre de la rosa</em>, de Umberto Eco.</p>
  <hr>
  <small>Desplegado por Aitor Saez en el servidor 2 $(hostname) el $(date '+%d/%m/%Y %H:%M')</small>
</body>
</html>
EOF
