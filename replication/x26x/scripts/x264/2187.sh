#!/bin/sh

numb='2188'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 30 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.2,1.3,4.8,0.2,0.9,0.4,1,2,6,30,230,4,30,0,3,4,63,28,3,1000,-2:-2,hex,show,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"