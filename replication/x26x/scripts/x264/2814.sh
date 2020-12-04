#!/bin/sh

numb='2815'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 50 --keyint 260 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.0,1.1,1.1,3.8,0.3,0.9,0.9,1,1,0,50,260,1,30,40,5,4,60,28,2,1000,1:1,umh,crop,veryslow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"