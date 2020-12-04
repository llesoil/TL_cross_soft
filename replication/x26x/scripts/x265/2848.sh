#!/bin/sh

numb='2849'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 25 --keyint 260 --lookahead-threads 1 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.4,1.0,3.2,0.6,0.9,0.1,0,0,14,25,260,1,20,10,3,3,68,48,3,1000,-1:-1,hex,show,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"