#!/bin/sh

numb='382'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 10 --keyint 220 --lookahead-threads 0 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.4,4.4,0.4,0.9,0.5,3,0,8,10,220,0,25,10,5,1,66,38,3,2000,-2:-2,dia,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"