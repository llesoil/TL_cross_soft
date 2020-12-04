#!/bin/sh

numb='552'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 0 --keyint 270 --lookahead-threads 2 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,3.0,1.0,1.4,0.8,0.4,0.7,0.8,0,0,8,0,270,2,29,30,5,0,65,48,6,2000,-1:-1,hex,show,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"