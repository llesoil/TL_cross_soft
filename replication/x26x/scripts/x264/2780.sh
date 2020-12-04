#!/bin/sh

numb='2781'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 5 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.3,1.4,1.6,0.4,0.6,0.4,1,2,14,5,210,2,22,10,3,3,68,18,3,2000,-1:-1,hex,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"