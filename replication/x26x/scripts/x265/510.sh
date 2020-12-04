#!/bin/sh

numb='511'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.0,1.1,1.3,2.6,0.5,0.8,0.6,1,0,6,5,260,0,25,50,5,1,64,38,3,2000,-2:-2,hex,show,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"