#!/bin/sh

numb='1438'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 35 --keyint 270 --lookahead-threads 2 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.0,1.2,1.2,1.2,0.5,0.9,0.3,0,2,4,35,270,2,29,10,3,2,64,28,4,1000,-1:-1,umh,crop,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"