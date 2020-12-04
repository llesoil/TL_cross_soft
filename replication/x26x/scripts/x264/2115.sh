#!/bin/sh

numb='2116'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 0 --keyint 220 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.4,1.0,0.6,0.4,0.8,0.2,1,2,8,0,220,2,20,10,3,0,64,18,4,2000,1:1,hex,crop,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"