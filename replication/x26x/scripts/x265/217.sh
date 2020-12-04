#!/bin/sh

numb='218'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 5 --keyint 300 --lookahead-threads 2 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.0,1.6,0.2,0.9,0.5,0,0,4,5,300,2,26,40,5,1,67,18,4,1000,-1:-1,umh,show,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"