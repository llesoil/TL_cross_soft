#!/bin/sh

numb='1190'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 50 --keyint 300 --lookahead-threads 4 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.5,1.3,2.2,0.2,0.6,0.9,3,0,12,50,300,4,28,30,4,2,62,18,5,1000,1:1,hex,show,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"