#!/bin/sh

numb='502'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 45 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 50 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.4,1.0,2.0,0.2,0.8,0.2,3,2,6,45,300,2,21,50,3,0,64,28,2,1000,1:1,umh,crop,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"