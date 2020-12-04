#!/bin/sh

numb='1049'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 40 --keyint 290 --lookahead-threads 4 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.0,1.1,1.2,2.8,0.4,0.6,0.1,2,2,4,40,290,4,28,20,5,2,69,18,2,1000,1:1,hex,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"