#!/bin/sh

numb='2186'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 40 --keyint 240 --lookahead-threads 4 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.5,1.2,2.8,0.5,0.9,0.1,0,0,2,40,240,4,26,30,5,2,64,18,2,2000,-2:-2,dia,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"