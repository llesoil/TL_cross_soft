#!/bin/sh

numb='2152'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 50 --keyint 280 --lookahead-threads 4 --min-keyint 21 --qp 10 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.5,1.0,3.0,0.2,0.9,0.7,3,0,12,50,280,4,21,10,5,4,63,18,3,1000,-2:-2,umh,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"