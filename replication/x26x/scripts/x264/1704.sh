#!/bin/sh

numb='1705'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 20 --keyint 240 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.4,1.4,4.0,0.3,0.7,0.7,1,1,0,20,240,1,21,30,4,4,65,48,2,1000,1:1,umh,show,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"