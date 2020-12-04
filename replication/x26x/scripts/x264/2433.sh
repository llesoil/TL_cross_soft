#!/bin/sh

numb='2434'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 40 --keyint 260 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryslow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.4,1.4,2.6,0.6,0.8,0.6,0,0,10,40,260,2,20,10,3,4,60,18,3,2000,-1:-1,hex,show,veryslow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"