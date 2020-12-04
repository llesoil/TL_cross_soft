#!/bin/sh

numb='1241'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 35 --keyint 270 --lookahead-threads 1 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.0,1.1,1.2,2.6,0.2,0.7,0.2,3,2,10,35,270,1,24,50,4,1,67,38,2,2000,-1:-1,dia,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"