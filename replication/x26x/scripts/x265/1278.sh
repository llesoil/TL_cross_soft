#!/bin/sh

numb='1279'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 35 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,None,--slow-firstpass,--no-weightb,2.5,1.1,1.3,4.4,0.4,0.9,0.1,2,1,10,35,240,4,30,0,3,3,68,28,1,2000,-2:-2,dia,crop,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"