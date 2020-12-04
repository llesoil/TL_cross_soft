#!/bin/sh

numb='1546'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 30 --keyint 280 --lookahead-threads 3 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.0,1.1,0.4,0.4,0.6,0.4,2,0,8,30,280,3,28,30,4,4,68,28,3,2000,-1:-1,dia,crop,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"