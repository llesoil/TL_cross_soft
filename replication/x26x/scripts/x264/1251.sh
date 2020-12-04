#!/bin/sh

numb='1252'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.0,1.2,4.6,0.3,0.9,0.2,0,2,4,45,220,1,24,10,3,1,60,28,3,2000,-2:-2,hex,crop,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"