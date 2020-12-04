#!/bin/sh

numb='1280'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 40 --keyint 290 --lookahead-threads 3 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.4,1.3,1.6,0.3,0.9,0.7,3,2,16,40,290,3,20,30,5,3,65,48,3,2000,-1:-1,hex,show,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"