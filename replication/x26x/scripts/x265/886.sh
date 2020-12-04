#!/bin/sh

numb='887'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 50 --keyint 240 --lookahead-threads 4 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.6,1.3,4.8,0.6,0.6,0.6,0,0,16,50,240,4,20,40,3,1,68,28,5,2000,-2:-2,dia,crop,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"