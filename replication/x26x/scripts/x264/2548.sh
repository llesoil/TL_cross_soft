#!/bin/sh

numb='2549'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 50 --keyint 260 --lookahead-threads 3 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.0,1.1,0.2,0.3,0.9,0.7,0,1,10,50,260,3,28,0,4,4,63,48,5,1000,-1:-1,hex,show,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"