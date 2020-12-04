#!/bin/sh

numb='1408'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 15 --keyint 240 --lookahead-threads 1 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.5,1.3,0.2,0.5,0.9,0.0,1,0,2,15,240,1,30,10,4,2,63,18,5,1000,-1:-1,dia,show,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"