#!/bin/sh

numb='822'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 5.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 5 --keyint 230 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.3,1.3,5.0,0.6,0.8,0.0,0,0,2,5,230,0,26,20,5,1,63,18,3,2000,-1:-1,hex,crop,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"