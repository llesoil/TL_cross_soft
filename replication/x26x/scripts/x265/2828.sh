#!/bin/sh

numb='2829'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 20 --keyint 240 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.6,1.1,4.4,0.6,0.9,0.3,3,1,14,20,240,1,30,50,5,3,62,48,6,2000,-1:-1,dia,crop,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"