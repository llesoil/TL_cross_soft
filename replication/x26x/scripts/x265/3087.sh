#!/bin/sh

numb='3088'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 5 --keyint 210 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.0,1.4,4.8,0.3,0.6,0.1,3,1,8,5,210,0,26,0,4,3,60,38,3,1000,1:1,umh,crop,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"