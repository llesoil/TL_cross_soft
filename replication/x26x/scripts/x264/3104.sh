#!/bin/sh

numb='3105'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 40 --keyint 210 --lookahead-threads 0 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.1,4.0,0.4,0.8,0.4,0,2,12,40,210,0,26,10,3,4,67,38,3,2000,-2:-2,umh,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"