#!/bin/sh

numb='1857'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.0,1.4,1.0,0.4,0.8,0.4,2,2,16,20,210,2,26,10,4,4,64,48,2,2000,-2:-2,umh,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"