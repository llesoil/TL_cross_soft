#!/bin/sh

numb='1536'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 0 --keyint 240 --lookahead-threads 3 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.0,1.1,3.6,0.6,0.6,0.4,1,1,0,0,240,3,23,20,4,1,64,28,5,1000,1:1,dia,show,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"