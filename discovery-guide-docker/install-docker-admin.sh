echo -e '\033[32m'
echo '============================================================='
echo '$                                                           $'
echo '$                     Nepxion Discovery                     $'
echo '$                                                           $'
echo '$                                                           $'
echo '$                                                           $'
echo '$  Nepxion Studio All Right Reserved                        $'
echo '$  Copyright (C) 2017-2050                                  $'
echo '$                                                           $'
echo '============================================================='

echo -n $'\e'"]0;Nepxion Discovery Guide [Admin]"$'\a'

PROJECT_NAME=discovery-guide-admin

DOCKER_HOST=tcp://localhost:2375
# DOCKER_CERT_PATH=/User/Neptune/.docker/machine/certs
IMAGE_NAME=guide-admin
MAIN_CLASS='com.nepxion.discovery.guide.admin.DiscoveryGuideAdmin'
MACHINE_PORT=6002
CONTAINER_PORT=6002
MIDDLEWARE_HOST=192.168.0.107
RUN_MODE='-i -t'
# RUN_MODE=-d

if [ ! -d ${PROJECT_NAME}/target ];then
  rmdir /s/q ${PROJECT_NAME}/target
fi

# 执行相关模块的Maven Install
mvn clean install -DskipTests -pl ${PROJECT_NAME} -am -DMainClass=${MAIN_CLASS}

# 停止和删除Docker容器
docker stop ${IMAGE_NAME}
# docker kill ${IMAGE_NAME}
docker rm ${IMAGE_NAME}

# 删除Docker镜像
docker rmi ${IMAGE_NAME}

cd ${PROJECT_NAME}

# 安装Docker镜像
mvn package docker:build -DskipTests -DImageName=${IMAGE_NAME} -DExposePort=${CONTAINER_PORT}

# 安装和启动Docker容器，并自动执行端口映射
# Windows下运行需要改成“winpty docker run”
docker run --env middleware.host=${MIDDLEWARE_HOST} ${RUN_MODE} -e TZ="Asia/Shanghai" -p ${MACHINE_PORT}:${CONTAINER_PORT} -h ${IMAGE_NAME} --name ${IMAGE_NAME} ${IMAGE_NAME}:latest

function pause(){
  echo 'Press any key to continue...'
  read -n 1 -p "$*" str_inp
  if [ -z "$str_inp" ];then
    str_inp=1
  fi
    if [ $str_inp != '' ];then
      echo -ne '\b \n'
    fi
}

pause