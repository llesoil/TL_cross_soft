#!/bin/sh

numb='155'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 40 --keyint 240 --lookahead-threads 2 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.5,1.0,1.2,0.4,0.7,0.4,0,1,8,40,240,2,20,20,5,2,68,18,5,1000,-1:-1,umh,show,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"