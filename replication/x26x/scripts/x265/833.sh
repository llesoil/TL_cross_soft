#!/bin/sh

numb='834'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 0 --keyint 290 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.5,1.0,1.6,0.3,0.8,0.6,3,1,6,0,290,2,29,40,3,3,67,38,4,2000,1:1,umh,show,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"