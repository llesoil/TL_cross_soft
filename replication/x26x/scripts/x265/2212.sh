#!/bin/sh

numb='2213'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 5 --keyint 300 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.0,1.0,1.0,4.0,0.6,0.6,0.5,0,0,10,5,300,3,30,10,5,2,65,28,3,1000,-1:-1,dia,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"