#!/bin/bash

set -xv
extension=".mkv"
software="$1"

cat listVideo.csv | while read line
  do
    read -d, videoname res fps < <(echo $line)
    path="./inputs/$videoname$extension"
    echo $path
    x26xconfigs=`ls ./scripts/$software/*.sh`
    csvOutput="./output/$software/$videoname.csv"
    if test -f "$csvOutput"; then
      echo "$csvOutput already exists"
    else
      echo "Starting to work with video: " $videoname
      header="configurationID,aud,constrained-intra,intra-refresh,no-asm,slow-firstpass,weightb,aq-strength,ipratio,pbratio,psy-rd,qblur,qcomp,vbv-init,aq-mode,b-adapt,bframes,crf,keyint,lookahead-threads,min-keyint,qp,qpstep,qpmin,qpmax,rc-lookahead,ref,vbv-bufsize,deblock,me,overscan,preset,scenecut,tune,size,user,system,elapsedtime,cpu,empty,fps,kbs"
      touch $csvOutput
      cat /dev/null > $csvOutput
      echo "$header" > $csvOutput
      for x26xconfig in $x26xconfigs
      do
        echo "Processing: " $x264config
        csvLine=`sh $x26xconfig $path "--input-res $res --fps $fps"`
        echo "$csvLine" >> $csvOutput
      done
      #rm "test.mp4"
  fi
done
echo "Done with video" $videoname

