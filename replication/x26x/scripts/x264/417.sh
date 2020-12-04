#!/bin/sh

numb='418'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 5 --keyint 280 --lookahead-threads 2 --min-keyint 27 --qp 50 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.3,1.2,2.0,0.2,0.9,0.8,2,1,14,5,280,2,27,50,3,3,67,48,2,1000,-1:-1,umh,crop,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"