# README

## Siscotel API - Sistema de Registro de Clientes
Esta es una API robusta desarrollada en Ruby on Rails para la gestión de clientes y registros de auditoría. El sistema implementa estándares modernos de seguridad, validaciones estrictas y persistencia de datos íntegra.

## Tecnologías Utilizadas
Lenguaje: Ruby 4.0.1

Framework: Ruby on Rails 8.1.2

Base de Datos: PostgreSQL

Autenticación: JSON Web Token (JWT)

Arquitectura: RESTful API

## Seguridad y Autenticación
El sistema utiliza JWT (JSON Web Token) para asegurar los endpoints.

Validación de Sesión: Cada petición a rutas protegidas debe incluir el header Authorization: Bearer <token>.

Hashing: Las contraseñas se almacenan cifradas utilizando el algoritmo BCrypt.

## Instalación y Configuración
1. Clonar el repositorio:
	bash
	```git clone https://github.com/SanGC75/prueba-ruby.git```
	```cd prueba_siscotel```

2. Instalar dependencias:
	bash
	```bundle install```

3. Configurar la base de datos:
	bash
	```rails db:create```
	```rails db:migrate```
	```rails db:seed```

4. Iniciar el servidor:
	bash
	```rails server```

## Endpoints Principales
| Método | Endpoint | Acción |
| :--- | :--- | :--- |
| **POST** | `/api/v1/auth/login` | Iniciar sesión |
| **DELETE** | `/api/v1/auth/logout` | Cerrar sesión |
| **GET** | `/api/v1/customers` | Listar clientes |
| **POST** | `/api/v1/customers` | Registrar cliente |
| **GET** | `/api/v1/customers/:id` | Ver detalle de cliente |
| **PATCH** | `/api/v1/customers/:id` | Actualizar cliente |
| **DELETE** | `/api/v1/customers/:id` | Eliminar (Soft Delete) |
| **PATCH** | `/api/v1/customers/:id/restore` | Restaurar cliente |

## Pruebas con Postman
En la carpeta `/docs` de este repositorio encontrarás la colección de Postman con todos los endpoints listos para probar.