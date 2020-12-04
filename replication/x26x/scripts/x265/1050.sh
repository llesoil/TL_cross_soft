#!/bin/sh

numb='1051'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 30 --keyint 240 --lookahead-threads 1 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.1,1.3,2.6,0.3,0.6,0.9,3,2,8,30,240,1,21,10,3,2,63,28,5,2000,-2:-2,umh,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"