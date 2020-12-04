#!/bin/sh

numb='2680'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 25 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.6,1.1,4.8,0.2,0.8,0.4,1,1,14,25,230,0,23,50,3,4,66,28,6,2000,1:1,dia,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"