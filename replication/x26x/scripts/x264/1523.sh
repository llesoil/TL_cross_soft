#!/bin/sh

numb='1524'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 10 --keyint 210 --lookahead-threads 1 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.4,1.4,1.0,0.5,0.8,0.3,2,0,6,10,210,1,20,30,5,0,60,18,5,1000,1:1,dia,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"