#!/bin/sh

numb='610'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 40 --keyint 260 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.0,1.0,1.2,2.2,0.6,0.6,0.7,3,1,0,40,260,1,26,20,4,0,60,48,6,1000,1:1,umh,crop,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"