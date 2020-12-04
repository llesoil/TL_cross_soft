#!/bin/sh

numb='1117'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 30 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.1,1.4,4.8,0.6,0.7,0.2,2,2,2,0,260,2,28,30,5,1,69,28,6,1000,-1:-1,hex,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"