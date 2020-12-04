#!/bin/sh

numb='1766'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 15 --keyint 290 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.0,1.0,3.8,0.3,0.6,0.4,1,0,14,15,290,0,27,10,4,2,67,48,4,2000,1:1,dia,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"