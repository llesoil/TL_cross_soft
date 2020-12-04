#!/bin/sh

numb='364'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 25 --keyint 270 --lookahead-threads 1 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.4,1.1,1.2,0.6,0.9,0.6,2,1,6,25,270,1,30,0,4,2,63,48,1,1000,1:1,hex,crop,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"