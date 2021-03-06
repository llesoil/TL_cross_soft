#!/bin/sh

numb='823'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 5 --keyint 240 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.0,1.3,1.2,4.0,0.3,0.9,0.3,3,1,0,5,240,3,20,10,4,2,68,18,6,1000,-1:-1,dia,crop,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"