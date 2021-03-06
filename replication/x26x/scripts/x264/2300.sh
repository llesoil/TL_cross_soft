#!/bin/sh

numb='2301'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 5.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 20 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.1,1.0,5.0,0.6,0.7,0.0,0,0,14,20,270,3,28,10,3,2,66,28,5,2000,1:1,hex,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"