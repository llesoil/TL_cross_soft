#!/bin/sh

numb='611'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 0 --keyint 270 --lookahead-threads 4 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.0,1.1,1.4,0.4,0.8,0.2,3,0,0,0,270,4,23,50,3,2,67,18,1,2000,-2:-2,hex,show,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"