#!/bin/sh

numb='1830'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 5 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,--no-asm,None,--no-weightb,3.0,1.2,1.2,0.8,0.2,0.9,0.2,2,1,2,5,220,2,26,10,3,3,67,28,1,1000,1:1,dia,show,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"