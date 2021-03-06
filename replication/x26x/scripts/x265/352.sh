#!/bin/sh

numb='353'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 3.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 50 --keyint 200 --lookahead-threads 1 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.6,1.2,3.6,0.5,0.6,0.7,2,2,4,50,200,1,29,20,4,1,65,48,4,2000,1:1,hex,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"