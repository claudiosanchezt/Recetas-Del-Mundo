# 🌐 Guía Completa: Configuración de Dominio en Servidor Debian con Docker

**Proyecto:** Recetas Del Mundo  
**Dominio:** recetasdelmundo.site (DonWeb)  
**Servidor:** Debian 12 (IP: 168.181.187.137)  
**Stack:** Docker + React (Frontend) + Spring Boot (Backend) + PostgreSQL + Nginx  
**Fecha:** 14 de noviembre de 2025

---

## 📋 Requisitos Previos

- ✅ **Dominio:** recetasdelmundo.site (hosteado en DonWeb - https://www.donweb.com)
- ✅ Acceso SSH al servidor: `ssh admin@168.181.187.137`
- ✅ Docker y Docker Compose instalados
- ✅ Aplicación funcionando en `http://168.181.187.137`
- ✅ DNS configurado apuntando a 168.181.187.137

---

## 🎯 Objetivo

Configurar tu dominio `recetasdelmundo.site` para que apunte al servidor, con:
- ✅ HTTPS automático (SSL gratuito con Let's Encrypt)
- ✅ Reverse proxy con Nginx
- ✅ Frontend accesible en `https://recetasdelmundo.site`
- ✅ Backend API en `https://recetasdelmundo.site/api`
- ✅ Renovación automática de certificados SSL

---

## 📝 PASO 1: Configurar DNS en DonWeb

### Acceder al Panel de DonWeb

1. Ingresa a https://www.donweb.com
2. Inicia sesión con tus credenciales
3. Ve a **"Mis Servicios"** o **"Panel de Control"**
4. Busca tu dominio `recetasdelmundo.site`
5. Click en **"Administrar DNS"** o **"Gestión de DNS"**

### Configurar Registros DNS

Agrega o modifica estos registros DNS:

**Registro A para el dominio principal:**
```
Tipo: A
Nombre: @  (o dejar vacío, representa recetasdelmundo.site)
Valor/IP: 168.181.187.137
TTL: 3600 (1 hora) o automático
```

**Registro A para www:**
```
Tipo: A
Nombre: www
Valor: 168.181.187.137
TTL: 3600
```

**Nota:** La propagación DNS puede tardar entre 5 minutos y 48 horas (generalmente 15-30 minutos).

**Verificar propagación desde tu PC local (PowerShell):**
```powershell
nslookup recetasdelmundo.site
ping recetasdelmundo.site
nslookup www.recetasdelmundo.site
```

**Respuesta esperada:**
```
Nombre:  recetasdelmundo.site
Address: 168.181.187.137
```

---

## 🔧 PASO 2: Conectarse al Servidor e Instalar Nginx + Certbot

```bash
# Conectarse al servidor
ssh admin@168.181.187.137

# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Nginx y Certbot
sudo apt install nginx certbot python3-certbot-nginx -y

# Verificar instalación
nginx -v
certbot --version
```

---

## ⚙️ PASO 3: Configurar Nginx como Reverse Proxy

### Crear archivo de configuración

```bash
sudo nano /etc/nginx/sites-available/recetas-del-mundo
```

### Pegar esta configuración (configurada para recetasdelmundo.site)

```nginx
# Configuración HTTP (se actualizará automáticamente a HTTPS por Certbot)
server {
    listen 80;
    listen [::]:80;
    server_name recetasdelmundo.site www.recetasdelmundo.site;

    # Logs
    access_log /var/log/nginx/recetas-access.log;
    error_log /var/log/nginx/recetas-error.log;

    # Aumentar tamaño máximo de upload (para imágenes de recetas)
    client_max_body_size 50M;

    # Frontend React (Puerto 80 del contenedor Docker)
    location / {
        proxy_pass http://localhost:80;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Backend API Spring Boot (Puerto 8081)
    location /api {
        # Reescribir /api/recetas → /recetas
        rewrite ^/api(.*)$ $1 break;
        
        proxy_pass http://localhost:8081;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # CORS headers (por si acaso)
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;
        
        # Timeouts para API
        proxy_connect_timeout 90s;
        proxy_send_timeout 90s;
        proxy_read_timeout 90s;
    }

    # Swagger UI - Documentación de API (Puerto 8081)
    location /swagger-ui {
        proxy_pass http://localhost:8081/swagger-ui;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # OpenAPI JSON
    location /v3/api-docs {
        proxy_pass http://localhost:8081/v3/api-docs;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }

    # pgAdmin (OPCIONAL - solo para desarrollo, quitar en producción)
    # location /pgadmin {
    #     proxy_pass http://localhost:8082;
    #     proxy_http_version 1.1;
    #     proxy_set_header Host $host;
    #     proxy_set_header X-Real-IP $remote_addr;
    #     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #     proxy_set_header X-Forwarded-Proto $scheme;
    # }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

### Activar configuración

```bash
# Crear enlace simbólico
sudo ln -s /etc/nginx/sites-available/recetas-del-mundo /etc/nginx/sites-enabled/

# Verificar sintaxis de configuración
sudo nginx -t

# Si dice "syntax is ok" y "test is successful", reiniciar Nginx
sudo systemctl restart nginx

# Verificar que está corriendo
sudo systemctl status nginx
```

---

## 🔒 PASO 4: Obtener Certificado SSL con Let's Encrypt

```bash
# Ejecutar Certbot
sudo certbot --nginx -d recetasdelmundo.site -d www.recetasdelmundo.site
```

**Responder las preguntas:**
1. **Email:** Ingresa un email válido (para notificaciones de renovación)
2. **Términos de servicio:** Acepta (A)
3. **Marketing emails:** No (N) o Sí (Y) - a tu elección
4. **Redirección HTTPS:** Elige opción 2 (Redirect) - Recomendado

**Resultado esperado:**
```
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/recetasdelmundo.site/fullchain.pem
Key is saved at: /etc/letsencrypt/live/recetasdelmundo.site/privkey.pem
```

### Verificar certificado instalado

```bash
# Ver certificados activos
sudo certbot certificates

# Verificar renovación automática
sudo certbot renew --dry-run
```

---

## 🐳 PASO 5: Actualizar Variables de Entorno del Frontend

### Opción A: Usando variables de entorno (Recomendado)

Edita el archivo `.env` del frontend:

```bash
cd /home/admin/Recetas-Del-Mundo/frontend
nano .env.production
```

Agrega:
```env
REACT_APP_API_URL=https://recetasdelmundo.site/api
REACT_APP_ENV=production
```

### Opción B: Modificar directamente el código

```bash
cd /home/admin/Recetas-Del-Mundo/frontend
nano src/api.js
```

Actualizar la configuración de Axios:

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: process.env.NODE_ENV === 'production' 
    ? 'https://recetasdelmundo.site/api'  // ⬅️ Tu dominio
    : 'http://localhost:8081',
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 30000,
});

// Interceptor para agregar token JWT
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default api;
```

---

## ⚙️ PASO 6: Configurar CORS en Backend Spring Boot

```bash
cd /home/admin/api-recetas_final/Springboot/src/main/resources
nano application.properties
```

Agregar/actualizar:

```properties
# CORS Configuration
allowed.origins=https://recetasdelmundo.site,https://www.recetasdelmundo.site,http://localhost:3000,http://localhost:80

# Server Configuration
server.port=8081
server.servlet.context-path=/

# Para producción, asegurar que esté configurado
spring.profiles.active=prod
```

Si tienes un archivo de configuración Java para CORS (`WebConfig.java`), actualizarlo:

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    @Value("${allowed.origins}")
    private String allowedOrigins;
    
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins(allowedOrigins.split(","))
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
```

---

## 🔄 PASO 7: Reconstruir y Reiniciar Contenedores Docker

```bash
cd /home/admin/api-recetas_final

# Detener contenedores
docker-compose down

# Reconstruir frontend con nueva configuración
docker-compose build frontend

# Recompilar backend (si se modificó)
cd Springboot
mvn clean package -DskipTests
cd ..

# Reconstruir backend
docker-compose build backend

# Levantar todos los servicios
docker-compose up -d

# Verificar que todo está corriendo
docker-compose ps

# Ver logs en tiempo real
docker-compose logs -f
```

**Servicios que deben estar "Up":**
- ✅ frontend (puerto 80)
- ✅ backend (puerto 8081)
- ✅ postgres (puerto 5432)
- ✅ pgadmin (puerto 8082) - opcional

---

## 🧪 PASO 8: Verificar Configuración

### Verificar Nginx

```bash
# Estado de Nginx
sudo systemctl status nginx

# Ver logs de acceso
sudo tail -f /var/log/nginx/recetas-access.log

# Ver logs de errores
sudo tail -f /var/log/nginx/recetas-error.log
```

### Verificar Certificado SSL

```bash
# Ver información del certificado
sudo certbot certificates

# Probar renovación automática
sudo certbot renew --dry-run

# Ver timer de renovación
sudo systemctl list-timers | grep certbot
```

### Pruebas desde navegador

1. **Frontend:** `https://recetasdelmundo.site`
   - Debe cargar la página de inicio
   - Verificar que NO hay errores de SSL

2. **Backend API:** `https://recetasdelmundo.site/api/recetas`
   - Debe retornar JSON con recetas
   - Verificar respuesta 200 OK

3. **Swagger:** `https://recetasdelmundo.site/swagger-ui/index.html`
   - Debe cargar documentación de API

### Pruebas desde terminal

```bash
# Probar HTTPS
curl -I https://recetasdelmundo.site

# Probar API
curl https://recetasdelmundo.site/api/recetas

# Verificar redirección HTTP → HTTPS
curl -I http://recetasdelmundo.site
```

---

## 🔐 PASO 9: Configurar Firewall (Seguridad Adicional)

```bash
# Instalar UFW (si no está instalado)
sudo apt install ufw -y

# Configurar reglas básicas
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Permitir SSH (IMPORTANTE - no te bloquees)
sudo ufw allow 22/tcp

# Permitir HTTP y HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Activar firewall
sudo ufw enable

# Ver estado
sudo ufw status verbose
```

---

## 📊 PASO 10: Monitoreo y Logs

### Ver logs de Docker

```bash
# Logs de todos los servicios
docker-compose logs

# Logs de un servicio específico
docker-compose logs frontend
docker-compose logs backend
docker-compose logs postgres

# Logs en tiempo real
docker-compose logs -f --tail=100
```

### Ver logs de Nginx

```bash
# Accesos
sudo tail -f /var/log/nginx/recetas-access.log

# Errores
sudo tail -f /var/log/nginx/recetas-error.log
```

### Ver uso de recursos

```bash
# Ver contenedores y recursos
docker stats

# Ver espacio en disco
df -h

# Ver memoria
free -h
```

---

## 🚨 Troubleshooting - Problemas Comunes

### Problema 1: "502 Bad Gateway"

**Causa:** Backend no está respondiendo o contenedor caído

**Solución:**
```bash
# Verificar contenedores
docker-compose ps

# Ver logs del backend
docker-compose logs backend

# Reiniciar backend
docker-compose restart backend

# Si persiste, reconstruir
docker-compose down
docker-compose up -d
```

### Problema 2: "ERR_CONNECTION_REFUSED"

**Causa:** Nginx no está corriendo o mal configurado

**Solución:**
```bash
# Verificar Nginx
sudo systemctl status nginx

# Verificar configuración
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx

# Ver logs
sudo tail -f /var/log/nginx/error.log
```

### Problema 3: "SSL Certificate Error"

**Causa:** Certificado no instalado o expirado

**Solución:**
```bash
# Ver certificados
sudo certbot certificates

# Renovar manualmente
sudo certbot renew --force-renewal

# Reiniciar Nginx
sudo systemctl restart nginx
```

### Problema 4: "CORS Policy Error" en navegador

**Causa:** CORS mal configurado en backend

**Solución:**
```bash
# Verificar allowed.origins en backend
cd /home/admin/api-recetas_final/Springboot/src/main/resources
grep "allowed.origins" application.properties

# Debe incluir tu dominio:
# allowed.origins=https://tudominio.com,https://www.tudominio.com

# Recompilar y reiniciar backend
cd /home/admin/api-recetas_final/Springboot
mvn clean package -DskipTests
cd ..
docker-compose restart backend
```

### Problema 5: "Cannot GET /api/recetas"

**Causa:** Rewrite de Nginx no funciona correctamente

**Solución:**
```bash
# Verificar configuración de Nginx
sudo nano /etc/nginx/sites-available/recetas-del-mundo

# Verificar esta línea en location /api:
# rewrite ^/api(.*)$ $1 break;

# Probar configuración
sudo nginx -t

# Reiniciar
sudo systemctl restart nginx
```

### Problema 6: Frontend carga pero API no funciona

**Causa:** Variable de entorno del frontend apunta a URL incorrecta

**Solución:**
```bash
# Verificar en navegador (F12 → Console):
# ¿Las llamadas van a https://tudominio.com/api o a localhost:8081?

# Actualizar frontend
cd /home/admin/Recetas-Del-Mundo/frontend
nano src/api.js
# Cambiar baseURL a: 'https://tudominio.com/api'

# Reconstruir frontend
cd /home/admin/api-recetas_final
docker-compose build frontend
docker-compose up -d frontend
```

---

## ✅ Checklist Final de Verificación

Marca cada ítem cuando esté completo:

### DNS y Red
- [ ] DNS apunta a la IP del servidor (168.181.187.137)
- [ ] `nslookup recetasdelmundo.site` resuelve correctamente
- [ ] `ping recetasdelmundo.site` responde

### Nginx y SSL
- [ ] Nginx instalado y corriendo
- [ ] Configuración de Nginx sin errores (`sudo nginx -t`)
- [ ] Certificado SSL instalado correctamente
- [ ] `https://recetasdelmundo.site` carga sin warnings de seguridad
- [ ] Redirección HTTP → HTTPS funciona

### Aplicación
- [ ] Frontend carga en `https://recetasdelmundo.site`
- [ ] Backend API responde en `https://recetasdelmundo.site/api/recetas`
- [ ] Login funciona correctamente
- [ ] Swagger accesible en `https://recetasdelmundo.site/swagger-ui/index.html`
- [ ] No hay errores CORS en consola del navegador
- [ ] Imágenes y assets cargan correctamente

### Docker
- [ ] Todos los contenedores están "Up"
- [ ] No hay errores en logs de Docker
- [ ] Frontend reconstruido con nueva configuración
- [ ] Backend con CORS actualizado

### Seguridad
- [ ] Firewall configurado (solo puertos 22, 80, 443 abiertos)
- [ ] Renovación automática de SSL configurada
- [ ] Headers de seguridad en Nginx configurados
- [ ] pgAdmin no expuesto públicamente (comentado en Nginx)

### Monitoreo
- [ ] Logs de Nginx accesibles
- [ ] Logs de Docker accesibles
- [ ] `docker stats` muestra uso de recursos normal

---

## 📚 Comandos Útiles de Referencia Rápida

```bash
# Ver estado de servicios
sudo systemctl status nginx
docker-compose ps

# Reiniciar servicios
sudo systemctl restart nginx
docker-compose restart

# Ver logs
sudo tail -f /var/log/nginx/recetas-error.log
docker-compose logs -f backend

# Renovar SSL
sudo certbot renew --dry-run

# Probar conectividad
curl -I https://recetasdelmundo.site
curl https://recetasdelmundo.site/api/recetas

# Verificar configuración
sudo nginx -t
docker-compose config

# Reconstruir aplicación
docker-compose down
docker-compose build
docker-compose up -d
```

---

## 📞 Soporte y Documentación Adicional

### Enlaces Útiles
- **Certbot:** https://certbot.eff.org/
- **Nginx Documentation:** https://nginx.org/en/docs/
- **Docker Compose:** https://docs.docker.com/compose/
- **Let's Encrypt:** https://letsencrypt.org/

### Información del Proyecto
- **Repositorio Backend:** https://github.com/claudiosanchezt/Recetas-Del-Mundo
- **Repositorio Frontend:** https://github.com/TioPig/Recetas-Del-Mundo
- **Servidor:** admin@168.181.187.137

---

## 📋 Resumen de Puertos

| Servicio | Puerto Interno | Puerto Externo | URL |
|----------|----------------|----------------|-----|
| Frontend (Nginx Docker) | 80 | 80 → 443 (HTTPS) | https://tudominio.com |
| Backend (Spring Boot) | 8081 | Proxy via Nginx | https://tudominio.com/api |
| PostgreSQL | 5432 | No expuesto | Solo localhost |
| pgAdmin | 8082 | No expuesto | Solo localhost |
| Nginx (Host) | - | 80, 443 | Reverse Proxy |

---

## 🎯 Configuración Recomendada Final

### Arquitectura de Producción

```
Internet
   ↓
DNS (tudominio.com → 168.181.187.137)
   ↓
Firewall (UFW: puertos 22, 80, 443)
   ↓
Nginx (Reverse Proxy + SSL)
   ├─→ Frontend Docker (puerto 80)
   ├─→ Backend Docker (puerto 8081)
   └─→ PostgreSQL Docker (puerto 5432)
```

### Variables de Entorno Finales

**Frontend (.env.production):**
```env
REACT_APP_API_URL=https://tudominio.com/api
REACT_APP_ENV=production
```

**Backend (application.properties):**
```properties
allowed.origins=https://tudominio.com,https://www.tudominio.com
server.port=8081
spring.profiles.active=prod
```

---

## ✨ ¡Listo! Tu aplicación ahora está en producción con dominio propio

Accede a:
- 🌐 **Aplicación:** https://tudominio.com
- 📚 **Documentación API:** https://tudominio.com/swagger-ui/index.html
- 🔐 **Todo con HTTPS seguro**

---

**Documento creado:** 14 de noviembre de 2025  
**Versión:** 1.0  
**Proyecto:** Recetas Del Mundo
