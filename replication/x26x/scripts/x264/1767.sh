#!/bin/sh

numb='1768'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 30 --keyint 220 --lookahead-threads 3 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.1,3.6,0.5,0.7,0.9,2,2,4,30,220,3,22,0,4,0,62,38,6,2000,-1:-1,umh,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"