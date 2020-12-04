#!/bin/sh

numb='2871'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 50 --keyint 230 --lookahead-threads 4 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.5,1.0,0.6,0.5,0.8,0.3,3,1,14,50,230,4,26,0,4,3,62,48,5,1000,-1:-1,hex,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"