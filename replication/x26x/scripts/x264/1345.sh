#!/bin/sh

numb='1346'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 50 --keyint 230 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.4,1.4,2.0,0.2,0.8,0.2,2,1,0,50,230,1,30,50,3,0,63,18,1,2000,-2:-2,dia,show,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"