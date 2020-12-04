#!/bin/sh

numb='695'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 0 --keyint 240 --lookahead-threads 1 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.0,1.2,2.2,0.3,0.7,0.8,2,0,14,0,240,1,28,40,5,2,62,18,6,1000,1:1,umh,crop,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"