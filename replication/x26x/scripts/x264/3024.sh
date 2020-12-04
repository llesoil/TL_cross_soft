#!/bin/sh

numb='3025'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 40 --keyint 300 --lookahead-threads 1 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.0,1.3,2.0,0.4,0.7,0.8,1,1,4,40,300,1,22,0,5,0,66,38,3,1000,-2:-2,hex,crop,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"