#!/bin/sh

numb='2314'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 0 --keyint 250 --lookahead-threads 3 --min-keyint 28 --qp 40 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.2,1.3,2.6,0.6,0.8,0.9,2,2,0,0,250,3,28,40,3,3,66,48,3,2000,-1:-1,dia,crop,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"