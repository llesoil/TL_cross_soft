#!/bin/sh

numb='2294'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 50 --keyint 230 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,3.0,1.3,1.3,4.4,0.2,0.8,0.7,2,0,4,50,230,1,30,30,5,1,63,18,1,1000,-1:-1,hex,show,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"