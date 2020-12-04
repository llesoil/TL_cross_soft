#!/bin/sh

numb='1337'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 30 --keyint 250 --lookahead-threads 2 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.0,1.4,4.0,0.3,0.9,0.7,3,2,16,30,250,2,23,50,3,1,68,38,2,2000,-2:-2,dia,show,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"