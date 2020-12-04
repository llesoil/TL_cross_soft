#!/bin/sh

numb='230'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 50 --keyint 280 --lookahead-threads 4 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.2,1.0,4.0,0.3,0.9,0.4,3,0,4,50,280,4,29,40,5,4,61,48,4,1000,-2:-2,umh,crop,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"