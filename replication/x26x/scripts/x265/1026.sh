#!/bin/sh

numb='1027'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 25 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.2,1.3,1.4,0.3,0.8,0.8,2,0,16,25,200,1,27,50,4,0,65,18,5,2000,1:1,hex,crop,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"