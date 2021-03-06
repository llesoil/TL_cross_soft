#!/bin/sh

numb='1749'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 50 --keyint 200 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.0,1.2,1.3,4.8,0.6,0.8,0.4,3,2,16,50,200,0,25,50,3,0,69,48,6,1000,-1:-1,hex,show,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"