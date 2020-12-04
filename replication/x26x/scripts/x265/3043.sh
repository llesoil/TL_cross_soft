#!/bin/sh

numb='3044'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 25 --keyint 230 --lookahead-threads 1 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.5,1.0,1.6,0.3,0.6,0.6,0,0,14,25,230,1,26,30,3,4,65,48,3,1000,1:1,hex,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"