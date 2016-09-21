#!/bin/bash

LOG_STASH_BIN="/opt/logstash/bin/logstash"
LOG_STASH_CONF_PROVIDER="/dc_elk/config/provider.conf"
LOG_STASH_CONF_C4_SAFE_KTRACE="/dc_elk/config/c4_safe_ktrace.conf"
TMP_CMD="/tmp/import_cmds.sh"
PARALLEL=6

function import_file {
  local FILE_PATH=$1
  #echo $FILE_PATH

  local SP="spa"
  if echo $FILE_PATH | grep --quiet -e '/spa/'; then
    SP="spa"
  else
    SP="spb"
  fi
  #echo $SP

  local FILE_NAME=$( echo $FILE_PATH | sed 's:^.*/::' | sed 's:log.*$:log:' )
  #echo $FILE_NAME

  local LOG_STASH_CONF=$LOG_STASH_CONF_PROVIDER
  if echo $FILE_PATH | grep --quiet -e 'cemtracer'; then
    LOG_STASH_CONF=$LOG_STASH_CONF_PROVIDER
  else
    LOG_STASH_CONF=$LOG_STASH_CONF_C4_SAFE_KTRACE
  fi

  local CAT=""
  if echo $FILE_PATH | grep --quiet -e 'gz'; then
    CAT="zcat"
  else
    CAT="cat"
  fi
  local CMD="$CAT $FILE_PATH | FILENAME=$FILE_NAME SP=$SP $LOG_STASH_BIN --allow-env -f $LOG_STASH_CONF"
  echo "echo '$CMD' && $CMD" >> $TMP_CMD
}

function import_dir {
  local ROOT_DIR=$1
  for SP_DIR in "$ROOT_DIR/spa" "$ROOT_DIR/spb"; do
    if [ -d $SP_DIR ]; then
      #echo "SP_DIR=$SP_DIR"
      for FILE_PATH in $( ls -1 $SP_DIR/EMC/CEM/log/cemtracer* $SP_DIR/EMC/C4Core/log/c4_safe_ktrace.log* 2>/dev/null ) ; do
        import_file $FILE_PATH
      done
    fi
  done
}

ROOT_DIR=$1
rm -fr $TMP_CMD
import_dir $ROOT_DIR
chmod a+x $TMP_CMD
#$TMP_CMD
cat /tmp/import_cmds.sh | xargs -d '\n' -n1 -P${PARALLEL} sh -c

#import_file "/home/vagrant/dc/auto_triage__Unity_400_service_data_FNM00153500391_2016-08-30_09_51_44/spb/EMC/CEM/log/cemtracer_uiservices.log.6.gz"
#import_file "/home/vagrant/dc/auto_triage__Unity_400_service_data_FNM00153500391_2016-08-30_09_51_44/spa/EMC/C4Core/log/c4_safe_ktrace.log"

