FROM cassandra:latest

# Copia tu archivo personalizado de configuración de Cassandra
COPY cassandra.yaml /etc/cassandra/cassandra.yaml

# Exponer el puerto 9042 (para consultas CQL) y 7000 (para Gossip)
EXPOSE 9042 7000

CMD ["cassandra", "-f"]
