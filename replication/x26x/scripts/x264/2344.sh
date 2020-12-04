#!/bin/sh

numb='2345'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 3.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 50 --keyint 300 --lookahead-threads 3 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.2,1.2,3.6,0.6,0.9,0.1,0,1,8,50,300,3,27,10,5,4,63,18,1,1000,-1:-1,dia,crop,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"