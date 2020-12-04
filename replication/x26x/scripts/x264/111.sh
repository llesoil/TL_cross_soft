#!/bin/sh

numb='112'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 20 --keyint 280 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.3,1.1,2.8,0.6,0.8,0.2,2,1,12,20,280,3,30,20,4,1,68,28,6,2000,-1:-1,dia,show,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"