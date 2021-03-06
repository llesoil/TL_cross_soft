#!/bin/sh

numb='2719'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 25 --keyint 260 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.0,1.1,0.2,0.3,0.8,0.4,1,2,16,25,260,1,30,30,3,3,64,48,4,1000,1:1,hex,crop,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"