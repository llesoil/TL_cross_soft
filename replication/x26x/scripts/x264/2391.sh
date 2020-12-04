#!/bin/sh

numb='2392'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 20 --keyint 230 --lookahead-threads 0 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.5,1.0,1.8,0.4,0.8,0.0,1,2,14,20,230,0,29,40,5,4,60,28,5,1000,1:1,hex,crop,veryslow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"