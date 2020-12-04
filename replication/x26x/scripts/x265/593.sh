#!/bin/sh

numb='594'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 20 --keyint 250 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.2,1.1,0.6,0.6,0.6,0.7,0,1,16,20,250,3,30,20,5,0,64,28,5,1000,1:1,umh,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"