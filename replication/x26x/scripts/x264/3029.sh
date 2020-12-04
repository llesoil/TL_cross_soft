#!/bin/sh

numb='3030'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 10 --keyint 290 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.4,1.3,0.6,0.2,0.9,0.0,2,0,6,10,290,4,29,0,5,3,67,28,2,2000,1:1,hex,show,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"