#!/bin/sh

numb='1416'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 20 --keyint 240 --lookahead-threads 0 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.0,1.4,0.4,0.4,0.9,0.3,0,2,14,20,240,0,21,0,5,4,69,48,1,2000,-2:-2,umh,crop,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"