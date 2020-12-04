#!/bin/sh

numb='2675'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 45 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.5,1.2,1.0,0.2,0.8,0.5,3,2,6,45,210,2,24,20,3,0,63,48,4,2000,-2:-2,dia,crop,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"