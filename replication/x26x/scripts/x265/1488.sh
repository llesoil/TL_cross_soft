#!/bin/sh

numb='1489'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 40 --keyint 280 --lookahead-threads 3 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.3,1.4,0.3,0.7,0.1,1,1,0,40,280,3,20,50,5,0,63,48,5,1000,-2:-2,dia,crop,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"