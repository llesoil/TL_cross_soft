#!/bin/sh

numb='1917'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 45 --keyint 230 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.4,1.1,3.2,0.2,0.9,0.2,2,1,10,45,230,1,23,10,3,3,63,48,3,1000,1:1,umh,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"