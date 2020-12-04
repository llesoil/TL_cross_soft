#!/bin/sh

numb='2308'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 0 --keyint 250 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.6,1.0,2.4,0.2,0.9,0.7,1,2,6,0,250,3,28,10,5,1,65,38,2,1000,-2:-2,hex,show,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"