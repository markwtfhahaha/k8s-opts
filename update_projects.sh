#!/bin/bash
#java jboss工程更新脚本#
#基于k8s系统部署应用#

if [ $# -ne 1 ]
then
    echo "Usage: "
    echo "    sh update_project.sh projectname"
    exit 1
fi

project=$1  #工程名
scriptsDir=/home/opts/k8s #脚本存放目录
k8sMasterIp=10.10.10.122  #k8s master ip,用于控制工程
nameSpace=mark-k8s-dev #k8s命名空间，用于区分项目

ftpdir=/home/ftp/ftptest/mark-k8s-dev  #工程ftp目录,默认最后定义为命名空间,这样好区分
gfsDir=/home/gluster-data #gfs基础目录，项目所有文件存储位置，这里挂载gfs volume

# gfsIp=10.10.10.131 #gfs IP 存储k8s系统持久化文件


getmark() {
    echo "************************************************************************************************************************"
}

#生成yml文件
getmark
cd $scriptsDir
echo "$project" yaml----------
./getxmlresult-k8s yml $project
getmark
echo "$project" nginx proxy----------
./getxmlresult-k8s nginx $project

datedir=`date +%Y%m%d`
javaname=`./getxmlresult-k8s xml $project | awk -F "|" '{print $2}'`
#ips=`./getxmlresult-k8s xml $project | awk -F "|" '{print $4}'` #废弃
p_type=`./getxmlresult-k8s xml $project | awk -F "|" '{print $3}'`


getmark

if [ "$p_type" == "jboss" ]
then
        srcdir=$ftpdir/jboss/$project/$datedir  #源目录
        destdir=$gfsDir/$nameSpace/$project  #目标目录
        echo "拷贝工程:$project/$javaname"
        echo "源目录: $srcdir"
        echo "目标目录: $destdir"
        
        #执行更新拷贝并且重启容器
        echo "执行更新拷贝并且重启容器"
        ansible $k8sMasterIp -m shell -a "ls $destdir || mkdir -p $destdir"
        ls $srcdir/$javaname
        if [ $? -ne 0 ]
        then
          echo "$srcdir/$javaname 源文件不存在,退出更新"
          exit 1
        fi
        ansible $k8sMasterIp -m synchronize -a "src=$srcdir/$javaname dest=$destdir/$javaname"
        
        echo "Restarting Deployment: $project"", namespce: $nameSpace"
        ansible $k8sMasterIp -m shell -a "kubectl rollout restart deployment $project -n $nameSpace"

        getmark
  
fi
if [ "$p_type" == "jar" ]
then
        srcdir=$ftpdir/java/$project/$datedir  #源目录
        destdir=$gfsDir/$nameSpace/$project  #目标目录
        echo "拷贝工程:$project/$javaname"
        echo "源目录: $srcdir"
        echo "目标目录: $destdir"
        
        #执行更新拷贝并且重启容器
        echo "执行更新拷贝并且重启容器"
        ansible $k8sMasterIp -m shell -a "ls $destdir || mkdir -p $destdir"
        ls $srcdir/$javaname
        if [ $? -ne 0 ]
        then
          echo "$srcdir/$javaname 源文件不存在,退出更新"
          exit 1
        fi
        ansible $k8sMasterIp -m synchronize -a "src=$srcdir/$javaname dest=$destdir/$javaname"
        
        echo "Restarting Deployment: $project"",namespce: $nameSpace"
        ansible $k8sMasterIp -m shell -a "kubectl rollout restart deployment $project -n $nameSpace"

        getmark
fi
if [ "$p_type" == "target.zip" ]
then
        srcdir=$ftpdir/java/$project/$datedir  #源目录
        destdir=$gfsDir/$nameSpace/$project  #目标目录
        echo "拷贝工程:$project/$javaname | $project/target.zip"
        echo "源目录: $srcdir"
        echo "目标目录: $destdir"
        
        #执行更新拷贝并且重启容器
        echo "执行更新拷贝并且重启容器"
        ls $srcdir/target.zip
        if [ $? -ne 0 ]
        then
          echo "$srcdir/target.zip 源文件不存在,退出更新" 
          exit 1
        else
          ansible $k8sMasterIp -m shell -a "rm -fr $destdir/*"
        fi
        ansible $k8sMasterIp -m shell -a "ls $destdir || mkdir -p $destdir"
        ansible $k8sMasterIp -m synchronize -a "src=$srcdir/target.zip dest=$destdir/target.zip"
        ansible $k8sMasterIp -m shell -a "cd $destdir && unzip target.zip"
        
        echo "Restarting Deployment: $project"",namespce: $nameSpace"
        ansible $k8sMasterIp -m shell -a "kubectl rollout restart deployment $project -n $nameSpace"

        getmark
fi
if [ "$p_type" == "html" ]
then
        srcdir=$ftpdir/html/$project/$datedir  #源目录
        destdir=$gfsDir/$nameSpace/html/$project  #目标目录
        echo "拷贝静态代码:$project"
        echo "源目录: $srcdir"
        echo "目标目录: $destdir"

        #执行更新拷贝
        echo "执行更新拷贝"
        
        ls $srcdir
        if [ $? -ne 0 ]
        then
          echo "$srcdir 源文件目录不存在,退出更新"
          exit 1
        fi
        ansible $k8sMasterIp -m shell -a "ls $destdir || mkdir -p $destdir"
        ansible $k8sMasterIp -m synchronize -a "src=$srcdir/ dest=$destdir/"
fi
getmark