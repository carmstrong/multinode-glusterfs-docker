#!/bin/bash
VOLUME=${VOLUME:-glustertest}
IPADDR=$(hostname -i)

# only create the volume if we're the master
if [ "$MASTER" == "$IPADDR" ]; then
  if [ ! -d "/var/lib/glusterd/vols/$VOLUME" ]; then
    READY=0
    while [ "$READY" -eq 0 ]; do
      READY=1
      for peer in $PEERS; do
        if [ "$peer" != "$IPADDR" ]; then
          gluster --mode=script peer probe $PEER
          if [ $? -eq 0 ]; then
            READY=0
          fi
        fi
      done
      sleep 5;
    done
    ## Always create a sub-directory inside a mount-point
    gluster --mode=script --wignore volume create $VOLUME replica 2 transport tcp $MOUNTS
  fi
  gluster --mode=script --wignore volume start $VOLUME force
fi

shutdown_gluster()
{
  stop glusterfs-server
  exit $?
}

trap shutdown_gluster SIGINT
while true; do sleep 60; done
