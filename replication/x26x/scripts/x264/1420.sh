#!/bin/sh

numb='1421'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 15 --keyint 270 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.2,4.8,0.3,0.8,0.7,3,2,8,15,270,2,30,50,4,4,67,48,2,1000,-1:-1,umh,crop,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"