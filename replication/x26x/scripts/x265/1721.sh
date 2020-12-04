#!/bin/sh

numb='1722'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 45 --keyint 240 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.3,1.1,3.8,0.2,0.8,0.4,2,2,16,45,240,1,29,30,4,4,61,38,2,1000,-2:-2,dia,crop,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"