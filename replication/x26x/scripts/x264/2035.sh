#!/bin/sh

numb='2036'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 45 --keyint 250 --lookahead-threads 3 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.4,2.6,0.3,0.8,0.6,2,1,2,45,250,3,22,40,4,4,60,38,2,1000,1:1,umh,show,fast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"