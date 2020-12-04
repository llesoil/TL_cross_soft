#!/bin/sh

numb='1176'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 10 --keyint 240 --lookahead-threads 2 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.5,1.0,1.0,3.8,0.3,0.8,0.0,2,1,10,10,240,2,21,20,3,3,67,48,6,1000,-2:-2,dia,show,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"