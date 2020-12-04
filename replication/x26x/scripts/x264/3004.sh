#!/bin/sh

numb='3005'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --intra-refresh --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 10 --keyint 240 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,None,None,--no-weightb,1.0,1.4,1.3,1.2,0.6,0.9,0.0,0,2,14,10,240,3,26,20,5,1,65,48,1,2000,-2:-2,umh,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"