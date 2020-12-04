#!/bin/sh

numb='1029'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 15 --keyint 240 --lookahead-threads 4 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.1,1.4,2.2,0.6,0.8,0.5,3,0,14,15,240,4,29,10,4,3,61,18,2,2000,-1:-1,hex,crop,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"