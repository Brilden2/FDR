docker pull neo4j

docker run -d -p 7474:7474 -p 7687:7687 --name neo4j \
 -e "NEO4J_AUTH=neo4j/Aa1335454." \
 -v /usr/local/soft/neo4j/data:/data \
 -v /usr/local/soft/neo4j/logs:/logs \
 -v /usr/local/soft/neo4j/conf:/var/lib/neo4j/conf \
 -v /usr/local/soft/neo4j/import:/var/lib/neo4j/import \
neo4j