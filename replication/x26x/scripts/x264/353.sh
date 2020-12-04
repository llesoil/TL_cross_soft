#!/bin/sh

numb='354'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 50 --keyint 300 --lookahead-threads 2 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.1,1.2,4.6,0.5,0.6,0.6,3,1,10,50,300,2,27,20,3,4,63,48,3,1000,1:1,dia,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"