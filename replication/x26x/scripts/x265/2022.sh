#!/bin/sh

numb='2023'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.4,1.1,3.0,0.2,0.7,0.2,2,0,14,45,220,1,27,10,5,4,63,48,6,1000,-1:-1,umh,crop,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"