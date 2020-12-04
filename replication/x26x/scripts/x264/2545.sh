#!/bin/sh

numb='2546'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 0 --keyint 240 --lookahead-threads 2 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.5,1.1,1.0,1.0,0.6,0.8,0.3,2,1,2,0,240,2,24,30,5,2,68,48,3,1000,-1:-1,dia,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"