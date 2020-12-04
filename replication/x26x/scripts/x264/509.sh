#!/bin/sh

numb='510'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 40 --keyint 220 --lookahead-threads 4 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.3,1.1,3.6,0.2,0.8,0.4,2,2,16,40,220,4,26,30,5,0,64,48,5,2000,1:1,umh,crop,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"