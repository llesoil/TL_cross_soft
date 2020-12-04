#!/bin/sh

numb='2034'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 40 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.5,1.1,0.6,0.6,0.6,0.1,1,1,0,40,300,2,21,30,5,3,66,18,5,2000,-1:-1,hex,crop,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"