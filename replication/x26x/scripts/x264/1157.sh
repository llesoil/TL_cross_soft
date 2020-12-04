#!/bin/sh

numb='1158'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 40 --keyint 220 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.0,1.1,1.6,0.4,0.9,0.7,1,0,14,40,220,4,24,50,3,2,60,28,3,2000,-1:-1,hex,show,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"