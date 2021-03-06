#!/bin/sh

numb='2105'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 15 --keyint 200 --lookahead-threads 1 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.2,1.0,1.2,0.4,0.7,0.0,2,0,2,15,200,1,21,0,4,4,63,38,2,1000,1:1,hex,show,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"