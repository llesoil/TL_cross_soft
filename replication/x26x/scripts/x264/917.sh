#!/bin/sh

numb='918'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 50 --keyint 260 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.0,1.1,3.2,0.5,0.8,0.8,1,1,4,50,260,0,25,0,3,0,61,48,1,1000,1:1,dia,crop,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"