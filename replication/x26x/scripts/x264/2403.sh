#!/bin/sh

numb='2404'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 40 --keyint 220 --lookahead-threads 2 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.1,2.2,0.6,0.6,0.3,2,1,4,40,220,2,27,40,3,4,61,28,6,2000,-1:-1,hex,show,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"