#!/bin/sh

numb='808'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 50 --keyint 290 --lookahead-threads 4 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.3,1.4,3.4,0.5,0.8,0.5,3,2,16,50,290,4,26,30,5,0,60,48,6,1000,-2:-2,hex,show,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"