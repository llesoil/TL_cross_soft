#!/bin/sh

numb='1476'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 45 --keyint 270 --lookahead-threads 0 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.4,1.0,3.4,0.2,0.6,0.0,3,2,12,45,270,0,28,50,4,0,62,28,4,1000,-1:-1,hex,show,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"