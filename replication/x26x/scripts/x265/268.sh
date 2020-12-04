#!/bin/sh

numb='269'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 0.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 35 --keyint 200 --lookahead-threads 4 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.3,1.3,0.6,0.2,0.6,0.3,0,0,8,35,200,4,26,20,5,0,68,48,4,2000,-2:-2,hex,crop,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"