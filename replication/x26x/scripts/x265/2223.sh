#!/bin/sh

numb='2224'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --intra-refresh --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,None,--slow-firstpass,--weightb,2.5,1.2,1.3,2.2,0.6,0.7,0.7,0,2,16,45,220,1,29,10,3,3,60,28,1,2000,-1:-1,umh,show,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"