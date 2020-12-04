#!/bin/sh

numb='1040'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 20 --keyint 250 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.3,1.0,3.6,0.5,0.7,0.9,2,2,2,20,250,0,27,0,5,0,63,48,3,2000,1:1,hex,crop,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"