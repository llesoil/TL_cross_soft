#!/bin/sh

numb='2559'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 10 --keyint 280 --lookahead-threads 0 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,3.0,1.4,1.2,3.6,0.6,0.9,0.7,1,0,4,10,280,0,21,20,5,4,64,18,6,2000,-2:-2,hex,show,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"