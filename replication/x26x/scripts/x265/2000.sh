#!/bin/sh

numb='2001'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 20 --keyint 220 --lookahead-threads 2 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.4,1.0,0.2,0.3,0.6,0.5,3,0,16,20,220,2,20,40,4,0,67,18,1,1000,1:1,umh,crop,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"