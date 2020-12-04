#!/bin/sh

numb='996'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 40 --keyint 240 --lookahead-threads 4 --min-keyint 25 --qp 10 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.5,1.2,1.8,0.4,0.6,0.2,2,1,14,40,240,4,25,10,4,4,65,38,4,2000,-1:-1,hex,crop,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"