#!/bin/sh

numb='2513'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 5 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.3,1.0,4.2,0.6,0.7,0.9,3,1,12,5,240,4,24,0,3,0,67,28,1,2000,1:1,dia,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"