#!/bin/sh

numb='385'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 25 --keyint 220 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.1,3.0,0.3,0.6,0.8,2,0,8,25,220,3,29,10,3,3,60,28,5,1000,-1:-1,hex,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"