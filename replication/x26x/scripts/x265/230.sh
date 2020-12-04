#!/bin/sh

numb='231'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 10 --keyint 260 --lookahead-threads 4 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.6,1.0,2.4,0.3,0.9,0.5,0,2,16,10,260,4,27,20,5,1,68,38,3,1000,-2:-2,hex,show,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"