#!/bin/sh

numb='619'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 0 --keyint 250 --lookahead-threads 2 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.5,1.2,1.3,1.2,0.4,0.9,0.6,1,1,4,0,250,2,29,0,3,4,68,38,6,1000,-1:-1,dia,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"