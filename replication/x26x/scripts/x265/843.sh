#!/bin/sh

numb='844'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 35 --keyint 230 --lookahead-threads 4 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.6,1.0,2.8,0.2,0.6,0.4,3,1,6,35,230,4,21,20,5,2,68,28,5,1000,1:1,hex,show,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"