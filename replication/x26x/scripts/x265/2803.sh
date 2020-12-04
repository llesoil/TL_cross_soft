#!/bin/sh

numb='2804'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 40 --keyint 240 --lookahead-threads 0 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.4,1.2,1.4,0.6,0.7,0.5,2,1,16,40,240,0,25,30,3,4,66,18,1,2000,1:1,hex,show,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"