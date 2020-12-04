#!/bin/sh

numb='2837'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 25 --keyint 200 --lookahead-threads 3 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.5,1.3,0.8,0.3,0.6,0.7,3,0,6,25,200,3,29,50,4,3,65,48,4,1000,-2:-2,hex,crop,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"