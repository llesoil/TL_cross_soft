#!/bin/sh

numb='980'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 40 --keyint 210 --lookahead-threads 4 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.5,1.1,1.1,0.8,0.4,0.6,0.4,0,2,0,40,210,4,26,50,5,0,63,18,2,2000,-1:-1,dia,show,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"