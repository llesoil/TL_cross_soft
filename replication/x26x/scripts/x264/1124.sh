#!/bin/sh

numb='1125'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 50 --keyint 280 --lookahead-threads 2 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.6,1.4,3.0,0.2,0.9,0.1,1,0,0,50,280,2,27,50,4,2,66,28,3,2000,-1:-1,umh,show,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"