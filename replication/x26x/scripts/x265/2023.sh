#!/bin/sh

numb='2024'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 35 --keyint 290 --lookahead-threads 4 --min-keyint 28 --qp 50 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.0,1.4,2.8,0.5,0.8,0.8,3,0,12,35,290,4,28,50,5,3,69,38,3,2000,-2:-2,hex,crop,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"