#!/bin/sh

numb='252'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 50 --keyint 280 --lookahead-threads 0 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.4,1.4,2.8,0.3,0.8,0.1,3,2,10,50,280,0,24,30,3,2,67,38,6,1000,-1:-1,hex,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"