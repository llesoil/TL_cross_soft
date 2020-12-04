#!/bin/sh

numb='2798'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 15 --keyint 280 --lookahead-threads 4 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.6,1.4,3.4,0.6,0.7,0.3,3,2,6,15,280,4,22,40,4,0,62,48,3,2000,1:1,umh,crop,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"