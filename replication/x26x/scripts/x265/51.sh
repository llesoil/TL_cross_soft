#!/bin/sh

numb='52'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 50 --keyint 280 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.5,1.4,4.0,0.5,0.6,0.9,0,1,12,50,280,2,21,10,3,3,64,38,6,1000,1:1,umh,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"