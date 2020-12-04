#!/bin/sh

numb='497'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 5.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 40 --keyint 240 --lookahead-threads 0 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.0,5.0,0.6,0.9,0.3,2,1,4,40,240,0,28,50,3,2,65,48,6,1000,1:1,umh,crop,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"