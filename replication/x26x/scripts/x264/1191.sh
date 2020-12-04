#!/bin/sh

numb='1192'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 15 --keyint 230 --lookahead-threads 0 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.5,1.0,0.6,0.3,0.9,0.2,3,0,10,15,230,0,26,10,4,4,65,48,4,2000,1:1,dia,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"