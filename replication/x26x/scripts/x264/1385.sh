#!/bin/sh

numb='1386'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 45 --keyint 290 --lookahead-threads 0 --min-keyint 28 --qp 30 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.5,1.3,2.6,0.2,0.6,0.7,3,2,2,45,290,0,28,30,5,3,64,28,4,2000,1:1,hex,crop,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"