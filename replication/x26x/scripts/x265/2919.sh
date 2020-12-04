#!/bin/sh

numb='2920'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 5 --keyint 280 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.6,1.2,2.6,0.5,0.8,0.5,3,1,2,5,280,0,23,30,5,4,65,28,4,2000,1:1,hex,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"