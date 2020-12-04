#!/bin/sh

numb='2985'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 50 --keyint 230 --lookahead-threads 0 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.1,1.2,4.8,0.6,0.9,0.2,2,0,10,50,230,0,26,30,4,1,68,18,2,2000,-1:-1,hex,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"