#!/bin/sh

numb='339'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 50 --keyint 290 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.3,1.4,1.6,0.4,0.7,0.1,1,1,10,50,290,0,24,20,4,3,67,48,2,1000,-1:-1,dia,show,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"