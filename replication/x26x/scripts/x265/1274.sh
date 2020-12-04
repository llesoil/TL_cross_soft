#!/bin/sh

numb='1275'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 25 --keyint 300 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.5,1.4,0.6,0.2,0.7,0.7,1,0,10,25,300,0,23,50,3,1,61,28,4,2000,-2:-2,hex,show,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"