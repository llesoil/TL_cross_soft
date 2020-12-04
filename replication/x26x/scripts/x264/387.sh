#!/bin/sh

numb='388'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 15 --keyint 290 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.3,1.4,3.0,0.4,0.9,0.7,2,0,2,15,290,0,27,0,3,2,66,38,5,1000,-2:-2,hex,crop,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"