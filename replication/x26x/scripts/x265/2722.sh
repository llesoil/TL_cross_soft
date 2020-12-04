#!/bin/sh

numb='2723'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 5.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 20 --keyint 240 --lookahead-threads 3 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.6,1.4,5.0,0.3,0.9,0.8,3,1,12,20,240,3,21,30,3,4,65,18,4,1000,-2:-2,umh,show,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"