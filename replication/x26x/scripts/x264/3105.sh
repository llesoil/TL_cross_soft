#!/bin/sh

numb='3106'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 40 --keyint 240 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.4,1.2,3.2,0.2,0.9,0.3,3,2,10,40,240,2,21,0,3,2,66,18,6,1000,-2:-2,dia,crop,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"