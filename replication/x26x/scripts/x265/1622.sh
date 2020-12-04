#!/bin/sh

numb='1623'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.5,1.6,1.3,0.4,0.4,0.9,0.9,1,2,2,40,270,0,30,30,5,2,63,48,4,2000,-2:-2,dia,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"