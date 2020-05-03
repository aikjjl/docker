docker安装
centos7
1、Docker 要求 CentOS 系统的内核版本高于 3.10 ，查看本页面的前提条件来验证你的CentOS 版本是否支持 Docker 。
通过 uname -r 命令查看你当前的内核版本
  uname -r
2、使用 root 权限登录 Centos。确保 yum 包更新到最新。
yum update
3、卸载旧版本(如果安装过旧版本的话)
yum remove docker  docker-common docker-selinux docker-engine
4、安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的
yum install -y yum-utils device-mapper-persistent-data lvm2
5、设置yum源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
6、可以查看所有仓库中所有docker版本，并选择特定版本安装
yum list docker-ce --showduplicates | sort -r
7、安装docker
yum install docker-ce  #由于repo中默认只开启stable仓库，故这里安装的是最新稳定版17.12.0
yum install <FQPN>  # 例如：sudo yum install docker-ce-17.12.0.ce
8、启动并加入开机启动
 systemctl start docker
 systemctl enable docker
9、验证安装是否成功(有client和service两部分表示docker安装启动都成功了)
 version









#docker
创建自定义网络，指定网段172.17.0.0/16 
docker network create --subnet=172.17.0.0/16 aikjjl
docker network ls
docekr run -it --name nginx_2 --net aikjjl --ip 192.168.1.2 -v /etc/localtime:/etc/localtime -p 80:80 ubuntu:latest bash

docker能干什么
简化配置（最重要）
代码流水线管理
提高开发效率
隔离应用
整合服务器
调试能力
多租户
快速部署

docker
kubernetes	k8s		容器编排工具

DevOps=文化+过程+工具
持续集成，发布，测试，监控，改进

1，容器技术和docker简介
2，docker环境的各种搭建方法
3，docker的镜像和容器
4，docker的网络
5，docker的持久化存储和数据共享
6，docker compose多容器部署

7，容器编排docker swarm
8，DevOps初体验——docker cloud和docker企业版
9，容器编排kubernetes
10，容器的运维和监控
11，docker+DevOps实战——过程工具	（开源免费）
12，总结



1，容器技术和docker简介
	1，虚拟化的优点
		资源池——物理机资源分配到虚拟机
		容易扩展——加物理服务器或虚拟器
		容易云化——亚马逊AWS，阿里云等
	2，虚拟化缺点
		每一个虚拟机都死一个完整的系统，本身就消耗很多资源，特别是虚拟机数量众多时
	############
	容器
		1，对软件和其依赖的标准化打包
		2，应用之间互相隔离
		3，共享同一个系统kernel
		4，可以运行在主流系统上
	############
	容器和虚拟机的区别
		容器是APP层面的隔离
		虚拟化是物理资源层面的隔离
	############	
	wordpress的docker部署
	
2，docker环境的各种搭建方法		
		virtualBox安装使用
		
		
3，docker的镜像和容器
	1，底层技术支持
		namespaces
		control groups：资源限制
		union file systems ：container和image的分层
		
	2，dockerfile
		FROM
		FROM centos	#base image基础镜像，尽量使用官方，安全角度
		FROM ubuntu:14.04	#可指定版本
		
		LABEL	#注释
		
		RUN		#安装软件使用，每使用一次RUN会生成一层image，务必使用\换行和&&
		RUN yum update 	&& yum install vim -y \
			yum install net-tools -y
			
		WORKDIR	#设定工作目录，类似cd
		WORKDIR /root	#没有目录时自动创建
		#不要使用RUN cd
		
		ADD and COPY	#把本地文件添加到image中
		ADD hello /		#把hello添加到/下
		ADD test.tar.gz /	#添加到根目录并解压			#区别
		COPY hello /		#把hello添加到/下
		#大部分情况COPY优于ADD，除了解压，添加远程文件使用curl或wget
		
		ENV		#设置常量
		ENV	MYSQL_VERSION 5.6	
		RUN apt install -y mysql-server= "${MYSQL_VERSION}"	#引用常量
		
		VOLUME and EXPOSE	#存储和网络
		
		
		RUN CMD ENTRYPOINT
		RUN	#执行命令并创建新的image layer
		CMD	#容器启动后默认执行的命令参数
			#如果docker run指定了其他命令，CMD命令被忽略
			#定义多个CMD，只有最后一个被执行
		ENTRYPOINT	#设置容器启动时运行的命令
			#让容器异应用程序或者服务形式运行
			#不会被忽略，一定会执行
			#最佳实践，写一个shell脚本最为entrypoint
		shell格式
			RUN apt install vim -y
			CMD echo "dada"
			ENTYPOINT echo "dada"
		exec格式
			RUN ["apt","install","-y","vim"]
			ENV name 11
			CMD ["/bin/echo", "dada"]
			ENTYPOINT ["/bin/echo", "dada"]
			
			ENTYPOINT ["/bin/bash", "-c","echo dada$name"]	#通过这样才能引用常量
		
		
		
		
	4，docker的网络
		1，端口映射
		
		2，
		none		#无IP和mac地址，只能通过docker exec 访问，安全性高，只能本地访问，存放密码
		host	#进入容器，看到网络接口和宿主机一样，没有独立的namaspace，和主机一样，可能会端口冲突
		
	5，多容器应用部署
		
		
		
		
6，docker compose多容器部署
	#批量处理工具
	通过yml文件定义docker应用
	docker-compose.yuml
		Services	#一个service代表一个container（从dockerhub或dockerfile创建）
		Networks
		Volumes
		
		例如：
			services:
				db:
					image:mysql
					volumes:
						-"db-data:/var/lib/mysql/"		#docker volume create db-data
					networks:
						-aikjjl
			#等于	
			docker run -d --network aikjjl -v db-data:/var/lib/mysql/ mysql
			
			services:
			worker:
				build: ./worker
				links:	#一般不用，当使用默认bridge时才有用
					- db
					- redis
				networks:
					- aikjjl	#docker network create -d bridge aikjjl
					




dockerfile
FROM ubuntu
ADD squid-4.7.tar.gz /usr/src/
WORKDIR /usr/src/squid-4.7
RUN mkdir /usr/local/squid && apt update -y && apt install gcc g++ make -y && ./configure --prefix=/usr/local/squid && make && make install




























































































	
		
		
		
		
		
		
		
		
		










