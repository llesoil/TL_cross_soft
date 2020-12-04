#!/bin/sh

numb='2718'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 5 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.4,1.2,1.8,0.6,0.8,0.3,3,0,2,5,200,0,30,40,5,2,67,48,4,2000,-2:-2,dia,show,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"