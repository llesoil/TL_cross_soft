#!/bin/sh

numb='3014'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 10 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.4,1.2,3.2,0.3,0.6,0.9,0,2,0,10,230,4,30,0,5,2,60,38,5,1000,1:1,hex,crop,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"