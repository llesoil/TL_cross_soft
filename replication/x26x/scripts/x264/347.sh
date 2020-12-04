#!/bin/sh

numb='348'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 5 --keyint 250 --lookahead-threads 1 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.1,1.3,0.2,0.5,0.8,0.6,0,0,12,5,250,1,20,50,5,3,62,18,4,2000,-2:-2,umh,crop,fast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"