#!/bin/bash

set -eux
set -o pipefail

function usage {
    echo "Usage: $(basename $0) <hadoop-version>"
}

if [[ $# -ne 1 ]]; then
    usage
    exit 1
fi

HADOOP_VERSION=${1}
case "${HADOOP_VERSION}" in
    "2.2.0" | "2.3.0" | "2.5.0" | "2.6.0" | "2.7.1")
        EXTRA_ARGS="-P hadoop2"
    ;;
esac

echo "Install required packages"
sudo apt-get install -y maven openjdk-7-jdk
mvn --version

echo "Build hadoop-openstack library"
pushd hadoop-swiftfs
mvn clean package ${EXTRA_ARGS:-} -Dhadoop.version=${HADOOP_VERSION}
mkdir -p ./../dist/hadoop-openstack/
mv target/hadoop-openstack-3.0.0-SNAPSHOT.jar ./../dist/hadoop-openstack/hadoop-openstack-${HADOOP_VERSION}.jar
popd
