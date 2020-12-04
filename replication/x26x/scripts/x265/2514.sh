#!/bin/sh

numb='2515'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 25 --keyint 230 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.4,1.2,0.4,0.6,0.7,0.8,1,1,2,25,230,1,30,30,4,2,64,38,6,2000,1:1,umh,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"