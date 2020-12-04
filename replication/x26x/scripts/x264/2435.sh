#!/bin/sh

numb='2436'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 5.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 0 --keyint 270 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.6,1.1,5.0,0.3,0.8,0.9,0,2,14,0,270,1,29,30,4,4,65,48,1,1000,1:1,dia,crop,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"