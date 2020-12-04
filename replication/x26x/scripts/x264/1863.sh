#!/bin/sh

numb='1864'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 10 --keyint 220 --lookahead-threads 0 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.5,1.1,3.0,0.3,0.9,0.3,3,0,14,10,220,0,21,10,4,1,62,28,3,2000,1:1,umh,crop,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"