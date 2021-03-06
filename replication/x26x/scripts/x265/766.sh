#!/bin/sh

numb='767'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 0.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 50 --keyint 260 --lookahead-threads 3 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 4 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.3,1.3,0.8,0.4,0.9,0.5,3,2,14,50,260,3,25,20,3,4,64,48,5,2000,-1:-1,hex,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"