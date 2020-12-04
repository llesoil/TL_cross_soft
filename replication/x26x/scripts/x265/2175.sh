#!/bin/sh

numb='2176'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 0 --keyint 240 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.4,1.3,0.8,0.5,0.8,0.2,0,1,6,0,240,3,22,50,5,2,66,28,3,1000,-1:-1,dia,show,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"