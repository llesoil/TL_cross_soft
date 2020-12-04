#!/bin/sh

numb='43'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 30 --keyint 290 --lookahead-threads 0 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.0,1.4,4.8,0.4,0.8,0.7,3,2,14,30,290,0,29,10,3,4,68,48,5,2000,1:1,dia,crop,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"