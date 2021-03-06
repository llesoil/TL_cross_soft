#!/bin/sh

numb='1471'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 0.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 30 --keyint 280 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.6,1.4,0.8,0.5,0.8,0.7,2,1,6,30,280,0,20,40,4,1,62,38,1,2000,-1:-1,hex,show,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"