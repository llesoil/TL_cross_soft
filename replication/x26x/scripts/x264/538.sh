#!/bin/sh

numb='539'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 5 --keyint 250 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.4,1.0,0.8,0.6,0.7,0.8,1,2,2,5,250,0,30,10,4,4,64,28,4,2000,1:1,dia,crop,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"