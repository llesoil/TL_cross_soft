#!/bin/sh

numb='877'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 25 --keyint 250 --lookahead-threads 0 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.5,1.4,1.4,4.2,0.6,0.7,0.7,0,0,10,25,250,0,29,50,3,1,65,38,2,1000,-2:-2,hex,crop,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"