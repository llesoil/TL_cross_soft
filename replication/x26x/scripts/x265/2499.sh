#!/bin/sh

numb='2500'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.3,1.3,1.4,0.4,0.6,0.5,0,2,10,40,260,0,30,50,5,2,65,18,1,1000,1:1,umh,crop,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"