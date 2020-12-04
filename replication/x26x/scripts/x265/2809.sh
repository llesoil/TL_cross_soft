#!/bin/sh

numb='2810'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 50 --keyint 280 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.5,1.3,2.6,0.3,0.8,0.1,3,0,4,50,280,2,21,10,3,2,66,28,1,2000,1:1,dia,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"