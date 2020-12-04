#!/bin/sh

numb='1463'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 50 --keyint 270 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.2,1.8,0.6,0.6,0.3,0,0,6,50,270,1,28,50,4,4,65,48,5,2000,-2:-2,hex,show,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"