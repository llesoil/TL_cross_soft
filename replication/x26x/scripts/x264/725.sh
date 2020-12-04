#!/bin/sh

numb='726'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 20 --keyint 240 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.1,1.2,0.4,0.3,0.9,0.3,1,2,2,20,240,2,20,50,5,4,64,28,5,1000,-2:-2,dia,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"