#!/bin/sh

numb='1738'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 35 --keyint 200 --lookahead-threads 1 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.1,1.3,2.8,0.6,0.8,0.6,2,1,10,35,200,1,22,0,5,4,64,48,5,2000,-2:-2,umh,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"