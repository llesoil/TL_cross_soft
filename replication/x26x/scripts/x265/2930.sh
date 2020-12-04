#!/bin/sh

numb='2931'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 10 --keyint 200 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.0,1.1,3.6,0.6,0.7,0.7,3,1,6,10,200,2,30,10,4,3,69,28,2,1000,-2:-2,umh,show,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"