#!/bin/sh

numb='2873'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 0 --keyint 300 --lookahead-threads 4 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.5,1.5,1.4,3.2,0.3,0.6,0.7,1,2,8,0,300,4,30,10,4,2,67,28,6,1000,-2:-2,hex,crop,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"