#!/bin/sh

numb='325'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 45 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 0 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.1,1.4,4.4,0.2,0.6,0.2,3,0,10,45,260,2,28,0,3,0,62,28,3,1000,-1:-1,umh,crop,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"