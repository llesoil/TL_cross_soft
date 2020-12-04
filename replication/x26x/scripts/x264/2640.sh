#!/bin/sh

numb='2641'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 50 --keyint 200 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.1,1.4,3.6,0.5,0.7,0.9,0,0,4,50,200,1,28,50,4,1,68,28,4,1000,1:1,hex,crop,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"