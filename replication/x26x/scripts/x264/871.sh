#!/bin/sh

numb='872'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 0 --keyint 290 --lookahead-threads 1 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.6,1.4,4.6,0.4,0.8,0.1,3,1,4,0,290,1,20,10,3,1,66,38,5,1000,1:1,hex,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"