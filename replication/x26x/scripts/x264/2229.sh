#!/bin/sh

numb='2230'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 45 --keyint 270 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.4,1.1,2.0,0.4,0.8,0.7,3,2,4,45,270,4,23,20,4,0,63,28,2,2000,-2:-2,dia,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"