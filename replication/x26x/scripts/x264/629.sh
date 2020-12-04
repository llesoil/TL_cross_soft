#!/bin/sh

numb='630'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 5.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 30 --keyint 200 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.4,1.1,5.0,0.3,0.9,0.6,2,0,10,30,200,0,27,10,4,4,66,38,2,2000,1:1,umh,crop,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"