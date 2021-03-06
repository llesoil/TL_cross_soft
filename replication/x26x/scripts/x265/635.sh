#!/bin/sh

numb='636'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 20 --keyint 280 --lookahead-threads 2 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.5,1.1,0.4,0.5,0.8,0.7,3,2,14,20,280,2,25,50,3,0,63,38,3,1000,1:1,dia,show,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"