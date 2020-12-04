#!/bin/sh

numb='3069'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 25 --keyint 240 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.6,1.1,4.0,0.6,0.7,0.3,1,1,10,25,240,2,30,50,3,2,62,18,6,1000,-1:-1,hex,crop,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"