#!/bin/sh

numb='658'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 5.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 50 --keyint 230 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.2,1.0,5.0,0.2,0.6,0.1,1,2,0,50,230,3,24,0,5,2,68,38,3,2000,-2:-2,dia,show,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"