#!/bin/sh

numb='125'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 5.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 40 --keyint 290 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.2,1.3,5.0,0.2,0.6,0.9,1,2,2,40,290,1,27,40,3,3,66,28,3,1000,1:1,umh,crop,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"