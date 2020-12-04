#!/bin/sh

numb='759'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 50 --keyint 240 --lookahead-threads 2 --min-keyint 28 --qp 0 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.0,1.0,1.2,0.5,0.7,0.9,1,1,4,50,240,2,28,0,3,1,62,48,3,2000,-1:-1,umh,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"