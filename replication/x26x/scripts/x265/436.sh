#!/bin/sh

numb='437'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 5.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 50 --keyint 260 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.3,1.3,5.0,0.2,0.6,0.3,2,2,0,50,260,0,22,0,4,4,64,48,3,1000,-2:-2,umh,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"