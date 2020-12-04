#!/bin/sh

numb='2139'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 5 --keyint 250 --lookahead-threads 2 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.5,1.3,1.2,2.6,0.2,0.6,0.3,2,0,10,5,250,2,26,0,5,2,67,18,2,2000,1:1,hex,crop,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"