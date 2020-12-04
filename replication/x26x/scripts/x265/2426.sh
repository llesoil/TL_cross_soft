#!/bin/sh

numb='2427'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 15 --keyint 280 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.5,1.4,2.6,0.5,0.6,0.3,1,1,10,15,280,2,21,0,5,3,62,18,2,2000,-2:-2,hex,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"