#!/bin/sh

numb='334'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 20 --keyint 220 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.4,1.1,4.6,0.5,0.6,0.7,2,2,14,20,220,3,20,40,3,2,62,48,4,1000,-1:-1,dia,crop,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"