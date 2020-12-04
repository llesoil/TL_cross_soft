#!/bin/sh

numb='3050'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 0 --keyint 200 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.0,1.4,2.6,0.4,0.9,0.3,3,1,6,0,200,2,26,50,4,1,63,38,2,1000,-1:-1,hex,show,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"