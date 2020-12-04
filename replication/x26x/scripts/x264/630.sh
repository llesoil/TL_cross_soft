#!/bin/sh

numb='631'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 20 --keyint 220 --lookahead-threads 2 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.5,1.3,4.2,0.6,0.7,0.6,2,0,14,20,220,2,28,10,4,0,68,18,1,2000,1:1,dia,show,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"