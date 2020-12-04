#!/bin/sh

numb='1091'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 5 --keyint 270 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.5,1.4,0.8,0.3,0.6,0.1,2,0,2,5,270,4,27,30,3,2,66,28,4,2000,-2:-2,umh,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"