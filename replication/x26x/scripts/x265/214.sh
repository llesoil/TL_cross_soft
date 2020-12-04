#!/bin/sh

numb='215'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 45 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.0,1.4,1.3,2.2,0.6,0.9,0.1,0,1,6,45,300,3,24,50,5,4,64,38,4,2000,-2:-2,dia,crop,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"