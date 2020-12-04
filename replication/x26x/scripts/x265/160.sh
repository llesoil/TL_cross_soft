#!/bin/sh

numb='161'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 5 --keyint 250 --lookahead-threads 1 --min-keyint 20 --qp 30 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.6,1.2,1.4,0.2,0.9,0.8,0,2,8,5,250,1,20,30,3,0,67,28,4,2000,-2:-2,dia,crop,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"