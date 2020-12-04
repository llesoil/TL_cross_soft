#!/bin/sh

numb='959'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.6,1.0,4.0,0.4,0.8,0.9,1,0,4,10,240,4,30,50,4,4,63,28,2,1000,-1:-1,dia,show,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"