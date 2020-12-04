#!/bin/sh

numb='554'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 20 --keyint 270 --lookahead-threads 1 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.5,1.0,1.0,0.6,0.9,0.8,0,1,0,20,270,1,26,50,3,1,63,28,3,2000,-2:-2,dia,show,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"