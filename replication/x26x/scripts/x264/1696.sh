#!/bin/sh

numb='1697'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 30 --keyint 220 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.2,1.2,0.2,0.4,0.7,0.7,0,2,14,30,220,3,20,40,3,2,66,38,2,1000,-1:-1,umh,show,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"