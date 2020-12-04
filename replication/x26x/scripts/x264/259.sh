#!/bin/sh

numb='260'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 45 --keyint 240 --lookahead-threads 4 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.6,1.1,3.0,0.6,0.6,0.3,0,2,2,45,240,4,25,30,3,2,66,38,5,1000,1:1,umh,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"