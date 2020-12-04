#!/bin/sh

numb='1074'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 30 --keyint 220 --lookahead-threads 1 --min-keyint 25 --qp 40 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.2,1.1,0.4,0.2,0.6,0.8,2,0,10,30,220,1,25,40,4,1,65,18,5,1000,-2:-2,umh,crop,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"