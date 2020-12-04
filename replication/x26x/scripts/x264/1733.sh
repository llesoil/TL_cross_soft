#!/bin/sh

numb='1734'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 4.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 15 --keyint 200 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.0,1.1,4.8,0.5,0.9,0.5,3,2,6,15,200,0,23,10,4,4,61,18,1,1000,-1:-1,hex,crop,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"