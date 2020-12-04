#!/bin/sh

numb='2716'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 0 --keyint 280 --lookahead-threads 1 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.5,1.1,2.4,0.6,0.8,0.7,0,1,10,0,280,1,30,10,5,0,63,18,5,1000,1:1,umh,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"