#!/bin/sh

numb='1023'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 5.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 5 --keyint 280 --lookahead-threads 1 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.1,1.3,5.0,0.5,0.6,0.6,3,1,8,5,280,1,20,50,3,2,63,38,1,2000,-2:-2,umh,show,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"