#!/bin/sh

numb='2192'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 5 --keyint 270 --lookahead-threads 4 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.2,1.2,4.4,0.3,0.9,0.0,1,1,6,5,270,4,21,20,5,3,66,18,5,2000,-2:-2,umh,show,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"