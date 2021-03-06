#!/bin/sh

numb='2799'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 25 --keyint 260 --lookahead-threads 1 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.2,1.1,3.2,0.4,0.7,0.9,2,1,0,25,260,1,29,20,3,0,63,28,5,2000,1:1,dia,show,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"