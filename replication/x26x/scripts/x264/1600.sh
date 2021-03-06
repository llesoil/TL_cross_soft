#!/bin/sh

numb='1601'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 25 --keyint 290 --lookahead-threads 3 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.3,1.3,1.0,0.5,0.6,0.4,3,0,8,25,290,3,22,30,5,2,67,28,1,1000,1:1,hex,crop,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"