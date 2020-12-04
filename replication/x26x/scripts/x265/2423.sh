#!/bin/sh

numb='2424'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 40 --keyint 300 --lookahead-threads 1 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.6,1.0,4.8,0.2,0.6,0.6,0,2,6,40,300,1,30,0,3,4,69,38,1,1000,1:1,dia,show,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"