#!/bin/sh

numb='2039'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 20 --keyint 290 --lookahead-threads 2 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.3,1.3,1.0,0.2,0.6,0.5,3,0,8,20,290,2,25,10,3,2,61,48,4,1000,1:1,dia,crop,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"