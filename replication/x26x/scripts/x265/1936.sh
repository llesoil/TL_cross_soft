#!/bin/sh

numb='1937'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 20 --keyint 300 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.3,1.4,3.4,0.3,0.9,0.8,1,1,16,20,300,2,20,50,5,4,63,28,1,1000,1:1,hex,crop,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"