#!/bin/sh

numb='2143'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 20 --keyint 290 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.5,1.1,4.2,0.6,0.8,0.0,3,0,6,20,290,0,23,30,4,0,65,48,6,1000,-1:-1,dia,show,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"