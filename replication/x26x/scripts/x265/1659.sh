#!/bin/sh

numb='1660'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 45 --keyint 250 --lookahead-threads 2 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.3,1.4,0.8,0.2,0.6,0.0,3,2,4,45,250,2,28,10,5,1,60,38,6,2000,1:1,dia,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"