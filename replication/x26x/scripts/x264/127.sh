#!/bin/sh

numb='128'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.3,1.2,3.4,0.2,0.6,0.7,3,2,8,40,260,0,25,40,5,1,64,38,1,1000,1:1,dia,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"