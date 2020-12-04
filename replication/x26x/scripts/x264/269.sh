#!/bin/sh

numb='270'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 40 --keyint 240 --lookahead-threads 4 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.3,1.4,1.2,0.3,0.8,0.5,1,0,14,40,240,4,29,30,5,4,65,48,4,2000,-2:-2,hex,crop,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"