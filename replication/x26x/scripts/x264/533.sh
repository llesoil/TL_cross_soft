#!/bin/sh

numb='534'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 35 --keyint 240 --lookahead-threads 1 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.0,1.2,4.2,0.3,0.7,0.3,1,2,2,35,240,1,21,20,3,2,60,18,6,1000,-2:-2,dia,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"