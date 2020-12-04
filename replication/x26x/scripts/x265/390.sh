#!/bin/sh

numb='391'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.2,1.4,3.4,0.3,0.7,0.9,1,1,4,20,210,2,20,10,5,1,69,18,6,2000,1:1,umh,show,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"