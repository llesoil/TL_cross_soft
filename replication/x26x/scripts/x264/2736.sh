#!/bin/sh

numb='2737'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 45 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.6,1.3,1.6,0.5,0.6,0.2,1,1,2,45,230,0,23,30,4,1,64,28,3,1000,-1:-1,dia,crop,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"