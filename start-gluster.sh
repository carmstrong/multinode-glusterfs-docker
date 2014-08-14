# Make sure rpcbind is started - GlusterNFS would complain
## RPC bind service will complain about Locale files but ignore
service rpcbind start

## Change this to your name if necessary
VOLUME=glustertest

## Start Gluster Management Daemon
service glusterd start

if [ -z $VOLUME ]; then
  ## Check if volume is null
  service glusterd stop
  exit 255
fi

if [ "$MASTER" ]; then
  if [ ! -d "/var/lib/glusterd/vols/$VOLUME" ]; then
    while ! gluster --mode=script peer probe gluster2.local.docker || ! gluster --mode=script peer probe gluster3.local.docker; do
      sleep 1;
    done
    ## Always create a sub-directory inside a mount-point
    gluster --mode=script --wignore volume create $VOLUME replica 2 transport tcp gluster1.local.docker:/exp1 gluster2.local.docker:/exp2 gluster3.local.docker:/exp3
  fi
  gluster --mode=script --wignore volume start $VOLUME force
fi

shutdown_gluster()
{
  service glusterd stop
  exit $?
}

trap shutdown_gluster SIGINT
while true; do sleep 1; done
