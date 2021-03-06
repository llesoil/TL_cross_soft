#!/bin/sh

numb='2568'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 5.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 15 --keyint 260 --lookahead-threads 4 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.0,1.1,1.0,5.0,0.4,0.7,0.4,2,1,6,15,260,4,29,40,4,3,69,48,1,2000,1:1,dia,crop,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"