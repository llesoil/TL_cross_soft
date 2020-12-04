#!/bin/sh

numb='703'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 5 --keyint 210 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.3,2.6,0.6,0.7,0.9,2,1,0,5,210,4,24,0,4,3,66,48,1,2000,1:1,hex,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"