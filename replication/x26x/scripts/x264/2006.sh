#!/bin/sh

numb='2007'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --intra-refresh --no-asm --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 10 --keyint 260 --lookahead-threads 1 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,--no-asm,None,--weightb,0.0,1.2,1.4,0.4,0.4,0.6,0.1,0,0,14,10,260,1,20,0,5,1,67,48,1,1000,-2:-2,umh,show,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"