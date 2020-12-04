#!/bin/sh

numb='2793'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 0 --keyint 280 --lookahead-threads 1 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,--slow-firstpass,--no-weightb,1.0,1.6,1.1,1.6,0.5,0.6,0.1,3,2,6,0,280,1,27,0,3,0,68,18,1,1000,-1:-1,hex,show,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"