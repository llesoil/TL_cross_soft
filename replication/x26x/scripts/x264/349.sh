#!/bin/sh

numb='350'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 0.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 35 --keyint 270 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.4,1.4,0.2,0.6,0.7,0.5,2,2,4,35,270,2,26,50,3,3,62,28,2,1000,1:1,dia,crop,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"