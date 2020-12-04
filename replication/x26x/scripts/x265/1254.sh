#!/bin/sh

numb='1255'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 5 --keyint 230 --lookahead-threads 3 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.2,1.1,0.4,0.2,0.9,0.1,2,1,10,5,230,3,21,20,3,2,68,28,4,2000,-2:-2,umh,crop,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"