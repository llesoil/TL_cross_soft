#!/bin/sh

numb='661'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.3,1.4,1.2,0.2,0.9,0.4,3,0,6,0,260,2,26,10,3,2,62,18,2,1000,1:1,umh,show,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"