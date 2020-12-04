#!/bin/sh

numb='2783'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 35 --keyint 240 --lookahead-threads 2 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.6,1.0,2.4,0.3,0.6,0.4,3,2,6,35,240,2,27,40,5,0,62,28,2,2000,-2:-2,hex,show,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"