#!/bin/sh

numb='1669'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 0 --keyint 270 --lookahead-threads 3 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.4,1.4,3.4,0.5,0.8,0.4,2,0,10,0,270,3,26,40,3,4,66,38,6,2000,-2:-2,hex,show,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"