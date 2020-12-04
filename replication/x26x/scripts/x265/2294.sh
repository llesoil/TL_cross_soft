#!/bin/sh

numb='2295'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 45 --keyint 290 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.3,1.3,4.6,0.2,0.9,0.7,3,2,6,45,290,1,27,10,5,3,60,48,1,1000,1:1,umh,show,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"