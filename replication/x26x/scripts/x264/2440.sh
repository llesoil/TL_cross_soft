#!/bin/sh

numb='2441'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 2.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 10 --keyint 280 --lookahead-threads 1 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.2,1.4,2.4,0.5,0.8,0.1,3,1,2,10,280,1,21,0,5,4,60,18,2,2000,-1:-1,hex,crop,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"