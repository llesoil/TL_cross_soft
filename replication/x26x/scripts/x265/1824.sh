#!/bin/sh

numb='1825'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 10 --keyint 260 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.3,1.4,2.4,0.4,0.8,0.2,3,1,2,10,260,2,26,50,4,2,66,48,6,2000,-1:-1,dia,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"