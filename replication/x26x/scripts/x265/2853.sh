#!/bin/sh

numb='2854'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 5.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 20 --keyint 280 --lookahead-threads 1 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.6,1.4,5.0,0.4,0.9,0.5,1,0,16,20,280,1,23,0,3,1,66,38,4,2000,-1:-1,dia,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"