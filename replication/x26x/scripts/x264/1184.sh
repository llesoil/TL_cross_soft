#!/bin/sh

numb='1185'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 15 --keyint 230 --lookahead-threads 0 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.4,3.8,0.6,0.6,0.0,3,0,12,15,230,0,27,30,5,3,68,38,3,1000,-2:-2,dia,crop,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"