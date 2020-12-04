#!/bin/sh

numb='2160'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 5 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.0,1.2,4.2,0.3,0.9,0.7,0,2,4,5,230,2,30,20,5,1,64,48,2,2000,-1:-1,hex,crop,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"