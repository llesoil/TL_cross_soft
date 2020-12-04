#!/bin/sh

numb='1608'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 25 --keyint 290 --lookahead-threads 0 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.6,1.0,1.6,0.4,0.6,0.6,1,1,0,25,290,0,20,10,4,0,68,38,1,1000,1:1,dia,crop,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"