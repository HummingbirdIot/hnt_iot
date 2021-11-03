#!/bin/bash
dockerContainer="hnt_iot_helium-miner_1"
otaDir="/var/for_ota"
snapshotName=`date "+%Y-%m-%d"`
snapshotSrcPath="/var/data/snap/${snapshotName}"
snapshotSrcHostPath="/var/data/miner/snap/${snapshotName}"
snapshotOtaPath="${otaDir}/${snapshotName}"

gen_snapshot() {
  mkdir -p ${otaDir}
  docker exec ${dockerContainer} miner snapshot take ${snapshotSrcPath}
  mv ${snapshotSrcHostPath} otaDir
}


clean_miner() {
  rm -fr /var/data/miner/state_channel.db
  rm -fr /var/data/miner/ledger.db
  rm -fr /var/data/miner/blockchain.db
}

apply_snapshot() {
  docker stop ${dockerContainer}

  cp ${snapshotOtaPath} ${snapshotSrcHostPath}
  docker start ${dockerContainer}
  docker exec ${dockerContainer} miner snapshot load ${snapshotSrcPath}
}


gen_snapshot
clean_miner
apply_snapshot
