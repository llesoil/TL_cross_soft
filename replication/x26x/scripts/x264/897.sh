#!/bin/sh

numb='898'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --intra-refresh --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 45 --keyint 230 --lookahead-threads 2 --min-keyint 29 --qp 30 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,None,--no-weightb,3.0,1.1,1.1,0.8,0.6,0.6,0.7,3,2,0,45,230,2,29,30,3,2,68,28,1,1000,1:1,umh,crop,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"