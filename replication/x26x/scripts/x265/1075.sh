#!/bin/sh

numb='1076'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 0 --keyint 200 --lookahead-threads 1 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.4,1.3,4.0,0.3,0.7,0.8,2,0,10,0,200,1,28,10,4,2,63,28,2,2000,-2:-2,dia,show,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"