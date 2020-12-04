#!/bin/sh

numb='1168'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 25 --keyint 220 --lookahead-threads 4 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.4,1.3,1.2,0.4,0.9,0.0,3,1,8,25,220,4,26,0,4,1,68,48,5,2000,-2:-2,umh,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"