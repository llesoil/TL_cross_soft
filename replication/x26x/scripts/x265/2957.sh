#!/bin/sh

numb='2958'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 0.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 25 --keyint 280 --lookahead-threads 0 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.4,1.4,0.2,0.6,0.8,0.8,3,0,6,25,280,0,27,50,5,1,66,48,1,1000,-2:-2,hex,crop,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"