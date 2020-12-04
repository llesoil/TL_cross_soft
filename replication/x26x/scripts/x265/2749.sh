#!/bin/sh

numb='2750'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 40 --keyint 290 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.6,1.3,2.2,0.2,0.9,0.9,2,1,12,40,290,3,23,30,3,3,65,48,2,1000,1:1,hex,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"