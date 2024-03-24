DOCKER_NETWORK = hbase
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
hadoop_branch := 3.3.6-java8-amd64
build:
	docker build -t zhongruizhi/hbase-base:$(current_branch) ./base
	docker build -t zhongruizhi/hbase-master:$(current_branch) ./hmaster
	docker build -t zhongruizhi/hbase-regionserver:$(current_branch) ./hregionserver
	docker build -t zhongruizhi/hbase-standalone:$(current_branch) ./standalone

wordcount:
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zhongruizhi/hadoop-base:$(hadoop_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zhongruizhi/hadoop-base:$(hadoop_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-2.7.4/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zhongruizhi/hadoop-base:$(hadoop_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zhongruizhi/hadoop-base:$(hadoop_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zhongruizhi/hadoop-base:$(hadoop_branch) hdfs dfs -rm -r /input
