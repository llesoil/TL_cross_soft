#!/bin/sh

numb='2044'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 40 --keyint 240 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.5,1.4,1.3,4.2,0.5,0.9,0.1,2,0,8,40,240,4,28,0,5,3,61,38,3,2000,-1:-1,dia,show,fast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"