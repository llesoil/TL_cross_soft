#!/bin/sh

numb='1581'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 28 --qp 40 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.5,1.1,3.2,0.3,0.9,0.2,3,1,12,45,220,1,28,40,3,4,67,38,2,1000,1:1,umh,show,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"