#!/bin/sh

numb='3021'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 35 --keyint 210 --lookahead-threads 0 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.2,1.2,4.6,0.5,0.9,0.2,2,1,6,35,210,0,23,0,3,1,68,18,2,1000,1:1,hex,crop,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"