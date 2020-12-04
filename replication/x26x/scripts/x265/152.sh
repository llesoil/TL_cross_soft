#!/bin/sh

numb='153'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 10 --keyint 280 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.5,1.3,3.6,0.2,0.8,0.7,2,0,2,10,280,4,27,40,5,4,68,38,6,2000,1:1,umh,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"