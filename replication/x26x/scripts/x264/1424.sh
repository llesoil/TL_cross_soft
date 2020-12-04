#!/bin/sh

numb='1425'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 0 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.2,0.4,0.3,0.6,0.6,2,0,6,0,240,4,24,0,5,4,67,28,5,1000,-1:-1,dia,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"