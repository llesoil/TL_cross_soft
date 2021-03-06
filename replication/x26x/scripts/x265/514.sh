#!/bin/sh

numb='515'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 0 --keyint 230 --lookahead-threads 0 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.2,1.0,4.0,0.2,0.7,0.0,0,1,0,0,230,0,21,0,5,0,65,38,3,1000,1:1,dia,show,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"