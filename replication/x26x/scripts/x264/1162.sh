#!/bin/sh

numb='1163'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 25 --keyint 300 --lookahead-threads 0 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.4,1.3,4.2,0.5,0.7,0.4,2,2,10,25,300,0,29,10,5,0,60,18,3,2000,1:1,dia,crop,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"