#!/bin/sh

numb='54'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 5.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 20 --keyint 250 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.2,1.1,5.0,0.3,0.6,0.2,2,0,12,20,250,1,22,40,3,0,62,38,2,1000,1:1,hex,crop,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"