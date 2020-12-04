#!/bin/sh

numb='1335'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 0.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 0 --keyint 290 --lookahead-threads 2 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.4,1.4,0.8,0.4,0.6,0.9,2,1,14,0,290,2,23,0,3,2,60,28,1,1000,-2:-2,umh,show,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"