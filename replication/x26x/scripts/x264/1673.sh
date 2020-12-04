#!/bin/sh

numb='1674'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 3.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 20 --keyint 200 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.2,3.8,0.4,0.8,0.6,2,1,4,20,200,2,29,20,4,1,65,48,3,1000,1:1,dia,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"