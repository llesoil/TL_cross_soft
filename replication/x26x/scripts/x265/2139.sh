#!/bin/sh

numb='2140'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 0.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 25 --keyint 260 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.6,1.0,0.2,0.3,0.7,0.7,3,2,6,25,260,1,28,50,4,4,63,38,3,1000,-1:-1,umh,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"