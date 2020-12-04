#!/bin/sh

numb='2611'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 15 --keyint 300 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.4,1.0,0.8,0.2,0.8,0.6,2,0,8,15,300,0,27,0,4,1,60,18,2,1000,-2:-2,umh,crop,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"