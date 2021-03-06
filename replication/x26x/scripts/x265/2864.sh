#!/bin/sh

numb='2865'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 45 --keyint 300 --lookahead-threads 1 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.4,1.3,3.0,0.4,0.8,0.8,0,1,8,45,300,1,27,20,5,4,60,18,3,2000,-1:-1,umh,show,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"