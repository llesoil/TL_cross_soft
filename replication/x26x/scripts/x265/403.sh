#!/bin/sh

numb='404'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 45 --keyint 200 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.3,1.0,3.8,0.2,0.7,0.8,1,0,4,45,200,1,25,20,5,3,68,18,6,2000,-2:-2,dia,show,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"