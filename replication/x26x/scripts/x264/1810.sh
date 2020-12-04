#!/bin/sh

numb='1811'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 40 --keyint 280 --lookahead-threads 0 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.6,1.0,2.6,0.4,0.9,0.2,3,2,6,40,280,0,25,30,3,3,64,18,4,2000,-1:-1,hex,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"