#!/bin/sh

numb='91'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 0 --keyint 290 --lookahead-threads 0 --min-keyint 20 --qp 0 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.2,1.0,2.6,0.6,0.9,0.5,2,1,0,0,290,0,20,0,3,1,66,48,1,1000,-1:-1,umh,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"