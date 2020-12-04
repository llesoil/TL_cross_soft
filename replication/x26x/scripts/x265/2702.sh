#!/bin/sh

numb='2703'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 15 --keyint 260 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.1,1.3,1.2,0.3,0.6,0.1,0,2,4,15,260,4,20,0,3,0,63,38,2,1000,-2:-2,hex,show,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"