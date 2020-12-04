#!/bin/sh

numb='1462'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 35 --keyint 290 --lookahead-threads 2 --min-keyint 25 --qp 10 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.0,1.2,1.0,3.6,0.4,0.8,0.6,3,0,14,35,290,2,25,10,4,4,67,38,3,2000,1:1,hex,show,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"