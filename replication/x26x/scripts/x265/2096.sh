#!/bin/sh

numb='2097'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 0 --keyint 250 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,--no-asm,--slow-firstpass,--no-weightb,1.0,1.0,1.0,1.4,0.3,0.8,0.7,1,1,10,0,250,0,25,40,5,1,61,18,1,1000,1:1,hex,crop,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"