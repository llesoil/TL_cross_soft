#!/bin/sh

numb='185'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 35 --keyint 260 --lookahead-threads 1 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.0,1.4,1.0,3.6,0.5,0.6,0.9,0,1,4,35,260,1,20,30,5,1,69,28,3,2000,-1:-1,dia,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"