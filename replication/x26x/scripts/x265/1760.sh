#!/bin/sh

numb='1761'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 5 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.2,1.3,3.0,0.5,0.8,0.6,2,2,8,5,260,2,28,50,5,1,63,38,1,1000,1:1,dia,show,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"