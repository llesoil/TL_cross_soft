#!/bin/sh

numb='2689'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 15 --keyint 280 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.0,1.2,2.2,0.4,0.9,0.9,2,1,0,15,280,1,26,20,3,1,62,18,3,1000,1:1,hex,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"