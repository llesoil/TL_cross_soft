#!/bin/sh

numb='1507'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 25 --keyint 200 --lookahead-threads 1 --min-keyint 23 --qp 0 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.6,1.0,4.2,0.5,0.7,0.4,2,2,8,25,200,1,23,0,4,4,67,38,2,2000,1:1,dia,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"