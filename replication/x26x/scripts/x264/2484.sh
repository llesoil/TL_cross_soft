#!/bin/sh

numb='2485'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 40 --keyint 240 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.0,1.3,1.2,0.3,0.7,0.9,3,0,8,40,240,0,22,20,3,1,67,28,6,1000,-1:-1,hex,crop,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"