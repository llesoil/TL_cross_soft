#!/bin/sh

numb='2811'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 0 --keyint 300 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.6,1.2,4.2,0.6,0.7,0.6,2,2,4,0,300,0,24,20,4,1,64,48,3,1000,1:1,dia,crop,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"