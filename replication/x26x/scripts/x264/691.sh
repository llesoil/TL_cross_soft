#!/bin/sh

numb='692'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 0 --keyint 220 --lookahead-threads 3 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.0,1.0,3.0,0.6,0.7,0.5,3,1,2,0,220,3,23,20,3,0,60,18,6,1000,-1:-1,hex,show,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"