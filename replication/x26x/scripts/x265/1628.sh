#!/bin/sh

numb='1629'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 0 --keyint 250 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.2,3.8,0.5,0.8,0.2,2,0,8,0,250,0,30,10,5,2,64,18,2,1000,-1:-1,dia,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"