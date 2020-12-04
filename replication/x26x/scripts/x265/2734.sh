#!/bin/sh

numb='2735'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 30 --keyint 220 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.6,1.3,4.8,0.5,0.6,0.5,3,2,16,30,220,2,29,20,5,0,64,28,2,2000,-2:-2,umh,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"