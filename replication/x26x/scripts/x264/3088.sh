#!/bin/sh

numb='3089'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 15 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.6,1.3,4.0,0.4,0.8,0.0,0,1,4,15,270,3,28,50,3,3,61,28,5,2000,1:1,umh,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"