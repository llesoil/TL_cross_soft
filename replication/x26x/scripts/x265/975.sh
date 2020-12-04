#!/bin/sh

numb='976'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 30 --keyint 290 --lookahead-threads 1 --min-keyint 23 --qp 50 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.6,1.1,0.8,0.2,0.8,0.9,2,0,8,30,290,1,23,50,4,1,63,38,2,1000,1:1,umh,crop,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"