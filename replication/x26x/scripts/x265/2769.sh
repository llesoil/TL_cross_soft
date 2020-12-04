#!/bin/sh

numb='2770'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 25 --keyint 240 --lookahead-threads 2 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.0,1.1,3.0,0.5,0.9,0.1,2,0,4,25,240,2,30,30,3,4,65,18,4,1000,1:1,umh,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"