#!/bin/sh

numb='1787'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 45 --keyint 230 --lookahead-threads 1 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.2,1.3,3.8,0.4,0.6,0.6,2,0,8,45,230,1,24,30,4,1,60,28,2,2000,-2:-2,hex,show,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"