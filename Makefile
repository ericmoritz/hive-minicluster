all: ${HADOOP_HOME} ${HIVE_HOME} setup



${HADOOP_HOME}:
	mkdir -p {cache,opt}
	curl -L -z cache/hadoop.tar.gz -o cache/hadoop.tar.gz ${HADOOP_URL}
	tar -C opt -xzf cache/hadoop.tar.gz

${HIVE_HOME}:
	mkdir -p cache
	curl -L -z cache/hive.tar.gz -o cache/hive.tar.gz ${HIVE_URL}
	tar -C opt -xzf cache/hive.tar.gz


setup:
	${HADOOP_HOME}/bin/hdfs namenode -format

	cp src/main/resources/hadoop/* ${HADOOP_HOME}/etc/hadoop/

	@make start-hdfs
	${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /user
	${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /user/${USER}

	${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /user
	${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /user/${USER}

	${HADOOP_HOME}/bin/hadoop fs -mkdir -p    /tmp
	${HADOOP_HOME}/bin/hadoop fs -mkdir -p    /user/hive/warehouse
	${HADOOP_HOME}/bin/hadoop fs -chmod g+w   /tmp
	${HADOOP_HOME}/bin/hadoop fs -chmod g+w   /user/hive/warehouse

	@make stop-hdfs

clean:
	rm -rf cache opt

start: start-hdfs start-yarn

start-hdfs:
	${HADOOP_HOME}/sbin/start-dfs.sh

start-yarn:
	${HADOOP_HOME}/sbin/start-yarn.sh

stop: stop-hdfs stop-yarn

stop-hdfs:
	${HADOOP_HOME}/sbin/stop-dfs.sh

stop-yarn:
	${HADOOP_HOME}/sbin/stop-yarn.sh

