#!/bin/sh

numb='2006'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 0 --keyint 300 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.3,1.4,3.6,0.4,0.7,0.1,0,1,8,0,300,1,28,50,4,2,68,28,6,1000,-2:-2,dia,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"