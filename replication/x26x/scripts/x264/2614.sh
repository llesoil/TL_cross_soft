#!/bin/sh

numb='2615'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 15 --keyint 210 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.6,1.2,2.8,0.2,0.7,0.7,3,2,8,15,210,4,30,30,5,3,61,28,1,1000,1:1,dia,crop,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"