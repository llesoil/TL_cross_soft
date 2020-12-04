#!/bin/sh

numb='436'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 0 --keyint 260 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.1,1.4,1.2,0.2,0.7,0.6,1,2,12,0,260,3,30,20,3,2,60,38,4,1000,1:1,dia,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"