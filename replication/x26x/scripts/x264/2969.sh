#!/bin/sh

numb='2970'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 30 --keyint 220 --lookahead-threads 4 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.2,1.0,3.6,0.2,0.7,0.7,2,0,0,30,220,4,29,50,3,3,68,48,5,2000,-2:-2,dia,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"