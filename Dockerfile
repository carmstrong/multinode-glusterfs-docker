FROM gluster/gluster:latest
MAINTAINER Chris Armstrong <chris@chrisarmstrong.me>
ADD start-gluster.sh /
CMD /bin/sh start-gluster.sh
