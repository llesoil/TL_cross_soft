#!/bin/sh

numb='1989'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 35 --keyint 280 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.3,1.1,0.6,0.5,0.6,0.5,0,2,4,35,280,4,27,40,3,2,63,18,2,1000,-2:-2,hex,crop,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"