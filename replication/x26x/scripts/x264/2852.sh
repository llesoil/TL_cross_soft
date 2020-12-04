#!/bin/sh

numb='2853'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 50 --keyint 270 --lookahead-threads 1 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.1,1.2,3.0,0.2,0.7,0.6,2,1,4,50,270,1,28,30,3,3,66,38,4,1000,-1:-1,dia,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"