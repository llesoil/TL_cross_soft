#!/bin/sh

numb='452'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 0 --keyint 210 --lookahead-threads 0 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.0,1.1,1.3,3.4,0.2,0.9,0.0,1,2,6,0,210,0,20,0,4,0,69,28,1,1000,-1:-1,dia,crop,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"