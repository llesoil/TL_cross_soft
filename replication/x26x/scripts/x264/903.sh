#!/bin/sh

numb='904'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 25 --keyint 240 --lookahead-threads 3 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.5,1.2,3.6,0.3,0.8,0.2,0,2,2,25,240,3,25,20,5,1,66,48,3,2000,1:1,umh,crop,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"