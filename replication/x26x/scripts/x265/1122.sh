#!/bin/sh

numb='1123'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 15 --keyint 270 --lookahead-threads 4 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.2,1.3,1.8,0.3,0.8,0.9,1,0,8,15,270,4,26,20,4,4,60,18,2,1000,-2:-2,hex,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"