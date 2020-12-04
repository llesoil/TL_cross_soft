#!/bin/sh

numb='2787'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 0 --keyint 230 --lookahead-threads 1 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.5,1.1,0.6,0.3,0.6,0.2,3,2,2,0,230,1,30,20,4,4,61,18,1,1000,1:1,hex,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"