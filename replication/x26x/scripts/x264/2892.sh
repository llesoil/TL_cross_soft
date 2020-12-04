#!/bin/sh

numb='2893'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 20 --keyint 220 --lookahead-threads 2 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.6,1.1,4.4,0.6,0.7,0.2,3,2,2,20,220,2,21,30,3,0,63,48,4,2000,-2:-2,umh,show,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"