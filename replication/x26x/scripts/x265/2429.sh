#!/bin/sh

numb='2430'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 15 --keyint 240 --lookahead-threads 1 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.1,1.1,2.6,0.5,0.7,0.3,1,1,12,15,240,1,30,0,4,2,60,28,3,2000,-1:-1,hex,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"