#!/bin/sh

numb='1997'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 5 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.0,1.2,3.8,0.6,0.9,0.4,0,2,2,5,300,3,24,10,3,4,64,18,6,1000,1:1,dia,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"