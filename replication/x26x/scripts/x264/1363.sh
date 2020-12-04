#!/bin/sh

numb='1364'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 40 --keyint 200 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.4,1.2,1.0,0.5,0.8,0.5,0,1,6,40,200,0,24,0,4,4,60,48,4,2000,-1:-1,hex,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"