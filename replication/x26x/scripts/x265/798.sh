#!/bin/sh

numb='799'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 40 --keyint 280 --lookahead-threads 3 --min-keyint 29 --qp 50 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.1,2.8,0.4,0.6,0.6,2,0,0,40,280,3,29,50,5,4,60,28,4,2000,-1:-1,hex,show,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"