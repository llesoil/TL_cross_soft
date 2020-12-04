#!/bin/sh

numb='2425'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 1.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 40 --keyint 230 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.6,1.4,1.4,0.2,0.7,0.0,2,2,14,40,230,0,22,0,5,0,67,28,5,1000,-1:-1,dia,crop,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"