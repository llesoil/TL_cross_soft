#!/bin/sh

numb='1'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 45 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.0,1.0,1.8,0.3,0.6,0.6,1,1,8,45,230,0,23,40,3,0,67,28,4,1000,-2:-2,umh,crop,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"