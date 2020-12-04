#!/bin/sh

numb='1990'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 30 --keyint 300 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.1,1.0,4.4,0.3,0.9,0.1,0,1,10,30,300,4,28,0,4,3,66,48,4,2000,-2:-2,hex,crop,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"