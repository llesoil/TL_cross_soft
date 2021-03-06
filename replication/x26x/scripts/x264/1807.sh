#!/bin/sh

numb='1808'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 30 --keyint 200 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.1,1.1,4.2,0.5,0.7,0.5,0,1,4,30,200,3,30,10,4,1,61,48,5,1000,1:1,dia,crop,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"