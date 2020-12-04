#!/bin/sh

numb='149'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 15 --keyint 260 --lookahead-threads 4 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.2,1.4,3.8,0.4,0.9,0.9,1,0,4,15,260,4,26,0,5,1,65,28,5,2000,-2:-2,hex,crop,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"