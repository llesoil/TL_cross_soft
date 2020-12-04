#!/bin/sh

numb='1949'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 45 --keyint 260 --lookahead-threads 1 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.2,1.0,3.4,0.5,0.8,0.0,1,2,10,45,260,1,25,30,3,3,62,18,2,1000,-2:-2,hex,show,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"