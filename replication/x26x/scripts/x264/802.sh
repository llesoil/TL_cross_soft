#!/bin/sh

numb='803'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 35 --keyint 240 --lookahead-threads 0 --min-keyint 29 --qp 30 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.3,1.2,4.2,0.5,0.7,0.1,3,1,10,35,240,0,29,30,3,2,62,48,5,1000,-2:-2,umh,crop,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"