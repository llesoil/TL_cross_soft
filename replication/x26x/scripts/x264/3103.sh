#!/bin/sh

numb='3104'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 5.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 20 --keyint 230 --lookahead-threads 3 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.1,1.1,5.0,0.2,0.8,0.7,3,0,6,20,230,3,30,30,4,0,61,18,1,2000,-1:-1,dia,show,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"