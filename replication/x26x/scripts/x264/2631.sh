#!/bin/sh

numb='2632'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 35 --keyint 220 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.1,1.3,2.0,0.4,0.6,0.7,0,0,8,35,220,0,22,20,5,2,65,18,2,1000,1:1,hex,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"