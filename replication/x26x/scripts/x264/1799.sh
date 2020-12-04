#!/bin/sh

numb='1800'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 20 --keyint 240 --lookahead-threads 2 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.4,1.0,1.8,0.5,0.6,0.9,0,2,12,20,240,2,26,30,5,0,67,38,4,1000,1:1,dia,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"