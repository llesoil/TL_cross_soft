#!/bin/sh

numb='641'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 5.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 40 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.1,1.2,5.0,0.4,0.9,0.8,1,1,4,40,300,2,21,40,4,2,67,38,5,1000,-2:-2,hex,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"