#!/bin/sh

numb='1302'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 35 --keyint 250 --lookahead-threads 4 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.4,2.6,0.2,0.7,0.4,3,2,16,35,250,4,21,10,4,0,69,48,4,1000,-1:-1,umh,crop,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"