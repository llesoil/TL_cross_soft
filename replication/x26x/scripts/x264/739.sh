#!/bin/sh

numb='740'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 2.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 20 --keyint 290 --lookahead-threads 3 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.2,1.4,2.4,0.3,0.6,0.9,0,0,16,20,290,3,28,0,5,3,60,48,2,2000,-2:-2,dia,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"