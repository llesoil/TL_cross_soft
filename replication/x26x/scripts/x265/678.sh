#!/bin/sh

numb='679'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 5 --keyint 220 --lookahead-threads 3 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.1,1.3,3.8,0.5,0.6,0.2,1,0,10,5,220,3,30,50,3,4,69,18,3,1000,-1:-1,umh,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"