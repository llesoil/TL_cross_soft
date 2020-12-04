#!/bin/sh

numb='1692'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 10 --keyint 220 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.3,1.0,3.4,0.6,0.7,0.0,1,2,14,10,220,0,30,0,5,0,66,48,3,1000,1:1,umh,crop,veryslow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"