#!/bin/sh

numb='879'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 15 --keyint 270 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.6,1.3,4.8,0.3,0.7,0.7,0,0,10,15,270,4,28,0,5,3,63,38,3,2000,-1:-1,dia,crop,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"