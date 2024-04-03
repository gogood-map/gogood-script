#!/bin/bash

# Verificar se o MySQL 8.0 está instalado
if ! command -v mysql &>/dev/null; then
    echo "Instalando MySQL 8.0..."
    sudo apt update
    sudo apt install -y mysql-server
    sudo systemctl start mysql
    sudo systemctl enable mysql

    # Criar o banco de dados e tabelas (como antes)
    echo "Criando banco de dados e tabelas..."
    sudo mysql <<EOF
    CREATE DATABASE IF NOT EXISTS GoGood;
    USE GoGood;

    CREATE TABLE IF NOT EXISTS usuarios (
      id INT AUTO_INCREMENT PRIMARY KEY,
      nome VARCHAR(255) NOT NULL,
      genero ENUM('M', 'F', 'O', 'PFN') NULL,
      sexualidade VARCHAR(255) NULL,
      dt_nascimento DATE NOT NULL,
      email VARCHAR(255) NOT NULL,
      senha VARCHAR(255) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS enderecos (
      id INT AUTO_INCREMENT PRIMARY KEY,
      cep CHAR(9) NOT NULL,
      rua VARCHAR(255) NOT NULL,
      numero INT NOT NULL,
      bairro VARCHAR(255) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS enderecos_usuarios (
      id INT AUTO_INCREMENT PRIMARY KEY,
      id_usuario INT NOT NULL,
      id_endereco INT NOT NULL,
      tipo_endereco ENUM('RESIDENCIAL', 'TRABALHO', 'ESCOLA', 'FACULDADE') NOT NULL,
      FOREIGN KEY (id_usuario) REFERENCES usuarios(id),
      FOREIGN KEY (id_endereco) REFERENCES enderecos(id)
    );

EOF
else
    echo "MySQL 8.0 já está instalado."
fi

# Verificar se o Docker está instalado
if ! command -v docker &>/dev/null; then
    echo "Instalando Docker..."
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
else
    echo "Docker já está instalado."
fi

# Iniciar container com imagem do Redis
echo "Iniciando container com imagem do Redis..."
sudo docker run -d --name redis-container redis

# Iniciar container com imagem do Java 17 (considerando que o Git e o Java estão instalados na imagem)

#!/bin/bash

# Verificar se o MySQL 8.0 está instalado (como antes)...

# Verificar se o Docker está instalado (como antes)...

# Iniciar container com imagem do Redis (como antes)...

# Verificar se a imagem do Java 17 está disponível e baixá-la, se necessário
if ! sudo docker image inspect openjdk:17 &>/dev/null; then
    echo "Baixando imagem do OpenJDK 17..."
    sudo docker pull openjdk:17
fi

# Iniciar container com imagem do Java 17
echo "Iniciando container com imagem do Java 17..."
sudo docker run -d --name java-container openjdk:17

# Clonar repositório Git
echo "Clonando repositório Git..."
sudo docker exec -it java-container git clone https://github.com/gogood-map/gogood-jar.git

# Executar arquivo .jar
echo "Executando arquivo .jar..."
sudo docker exec -it java-container java -jar gogood-api

echo "Script de instalação concluído."
