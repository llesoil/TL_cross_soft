#!/bin/sh

numb='376'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 10 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.2,1.4,4.8,0.3,0.7,0.7,2,0,6,10,210,2,22,40,4,0,61,18,3,2000,1:1,hex,crop,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"