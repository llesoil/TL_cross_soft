#!/bin/sh

numb='2163'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 20 --keyint 280 --lookahead-threads 4 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.4,1.0,3.8,0.2,0.7,0.7,1,0,6,20,280,4,25,0,5,3,67,18,6,1000,1:1,hex,crop,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"