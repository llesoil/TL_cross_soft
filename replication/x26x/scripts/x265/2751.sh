#!/bin/sh

numb='2752'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 40 --keyint 260 --lookahead-threads 4 --min-keyint 24 --qp 20 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.1,1.4,0.4,0.6,0.6,0.6,3,2,6,40,260,4,24,20,3,3,66,48,2,2000,-1:-1,dia,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"