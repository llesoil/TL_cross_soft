#!/bin/sh

numb='1659'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 25 --keyint 220 --lookahead-threads 3 --min-keyint 21 --qp 20 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.1,1.0,2.4,0.2,0.7,0.9,0,0,2,25,220,3,21,20,4,2,68,18,1,1000,1:1,dia,crop,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"