#!/bin/sh

numb='1293'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 10 --keyint 300 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.3,1.1,3.8,0.5,0.6,0.6,1,1,4,10,300,1,23,10,3,0,68,38,2,2000,-2:-2,dia,show,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"