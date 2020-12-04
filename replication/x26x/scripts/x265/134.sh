#!/bin/sh

numb='135'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 10 --keyint 240 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.1,1.1,1.2,0.5,0.7,0.7,1,2,10,10,240,2,30,50,3,1,68,18,1,1000,-2:-2,umh,crop,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"