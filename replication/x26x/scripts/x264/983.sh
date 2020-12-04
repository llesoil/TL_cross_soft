#!/bin/sh

numb='984'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 25 --keyint 250 --lookahead-threads 3 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.5,1.6,1.0,3.4,0.2,0.8,0.2,1,2,10,25,250,3,27,50,4,1,60,38,4,1000,1:1,dia,crop,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"