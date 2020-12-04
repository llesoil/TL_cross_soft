#!/bin/sh

numb='1044'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 30 --keyint 240 --lookahead-threads 4 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.4,1.1,4.4,0.5,0.7,0.7,0,0,12,30,240,4,27,0,3,3,64,28,3,1000,1:1,umh,crop,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"