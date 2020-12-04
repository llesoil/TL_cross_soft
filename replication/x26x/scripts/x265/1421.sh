#!/bin/sh

numb='1422'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 50 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.1,1.2,2.4,0.4,0.7,0.9,1,0,8,50,260,0,20,40,5,1,68,48,1,1000,1:1,dia,crop,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"