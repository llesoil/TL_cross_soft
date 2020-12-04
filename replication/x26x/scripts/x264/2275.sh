#!/bin/sh

numb='2276'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 5 --keyint 230 --lookahead-threads 1 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.1,1.2,0.8,0.3,0.6,0.1,1,1,0,5,230,1,25,10,3,3,63,38,5,1000,-2:-2,hex,crop,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"