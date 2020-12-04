#!/bin/sh

numb='750'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 10 --keyint 300 --lookahead-threads 1 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.5,1.2,4.8,0.3,0.7,0.5,1,0,8,10,300,1,23,50,5,0,62,48,4,1000,1:1,dia,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"