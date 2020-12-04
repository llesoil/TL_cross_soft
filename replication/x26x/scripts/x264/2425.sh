#!/bin/sh

numb='2426'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 15 --keyint 200 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.0,1.5,1.0,2.2,0.3,0.9,0.1,1,1,14,15,200,3,28,10,3,3,69,18,2,2000,-2:-2,hex,show,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"