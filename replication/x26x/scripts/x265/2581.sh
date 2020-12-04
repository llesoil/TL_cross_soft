#!/bin/sh

numb='2582'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 50 --keyint 290 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.3,1.3,3.6,0.6,0.9,0.6,1,0,6,50,290,1,22,40,4,2,61,28,2,2000,-1:-1,umh,show,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"