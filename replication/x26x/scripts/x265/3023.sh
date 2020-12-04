#!/bin/sh

numb='3024'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.5,1.3,4.4,0.4,0.9,0.3,0,0,4,35,230,3,30,30,3,2,60,48,2,1000,-1:-1,hex,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"