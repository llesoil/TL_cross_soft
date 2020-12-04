#!/bin/sh

numb='689'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 25 --keyint 250 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.2,1.1,1.6,0.3,0.7,0.9,3,1,8,25,250,3,20,10,5,3,61,38,3,2000,-2:-2,dia,crop,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"