#!/bin/sh

numb='2451'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 5 --keyint 250 --lookahead-threads 4 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.5,1.4,0.8,0.3,0.6,0.5,1,0,10,5,250,4,24,10,5,0,66,28,4,2000,1:1,umh,crop,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"