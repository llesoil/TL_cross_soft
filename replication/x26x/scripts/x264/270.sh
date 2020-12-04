#!/bin/sh

numb='271'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 0 --keyint 200 --lookahead-threads 2 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.0,1.2,0.2,0.4,0.8,0.4,2,1,4,0,200,2,27,10,4,4,66,28,4,1000,1:1,umh,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"