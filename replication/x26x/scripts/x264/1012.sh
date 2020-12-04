#!/bin/sh

numb='1013'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 25 --keyint 290 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.0,1.2,1.2,0.6,0.9,0.9,3,0,12,25,290,2,22,20,4,0,67,18,1,1000,1:1,umh,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"