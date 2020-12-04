#!/bin/sh

numb='2236'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 45 --keyint 290 --lookahead-threads 1 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.0,1.4,1.0,2.8,0.4,0.7,0.8,2,0,12,45,290,1,22,10,5,1,65,48,3,2000,1:1,hex,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"