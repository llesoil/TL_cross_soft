#!/bin/sh

numb='241'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 45 --keyint 260 --lookahead-threads 4 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.2,1.4,3.2,0.6,0.6,0.6,1,2,0,45,260,4,28,20,3,1,64,28,6,1000,-2:-2,hex,show,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"