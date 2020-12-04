#!/bin/sh

numb='855'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 40 --keyint 300 --lookahead-threads 4 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.2,1.2,4.6,0.2,0.7,0.3,0,0,2,40,300,4,29,50,3,1,68,28,6,2000,-2:-2,dia,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"