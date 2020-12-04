#!/bin/sh

numb='1218'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --intra-refresh --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 45 --keyint 200 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,None,--weightb,0.0,1.6,1.1,3.2,0.6,0.9,0.6,0,0,14,45,200,3,29,10,4,0,64,18,1,2000,1:1,umh,show,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"