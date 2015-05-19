#!/bin/sh
#****************************************************************#
# ScriptName: done.sh
# Author: shoukun.taosk@alibaba-inc.com
# Create Date: 2012-05-30 16:21
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-18 21:42
# Function: 
#***************************************************************#
PWD=`pwd`
for i in `ls post/*.sh`
do
	bash -n $i
	[ $? != 0 ]&& echo "$i.sh error"&&exit 1
done

if [ -e post.tgz ]
  then
	mv post.tgz bak/post-`date +%Y%m%d%H%M%S`.tgz
	path="$PWD/bak/"
	find $path -type f -mtime +3|xargs rm -rf
  else
	:
fi
cd post
tar -zcvf ../post.tgz .
