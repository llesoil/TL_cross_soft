#!/bin/sh

numb='247'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 0.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 5 --keyint 250 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.3,1.3,0.6,0.5,0.9,0.4,3,2,14,5,250,2,24,20,4,2,63,48,3,1000,-2:-2,dia,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"