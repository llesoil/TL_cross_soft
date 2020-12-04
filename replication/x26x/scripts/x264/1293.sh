#!/bin/sh

numb='1294'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 30 --keyint 270 --lookahead-threads 0 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.5,1.1,4.8,0.4,0.8,0.3,3,0,8,30,270,0,20,10,4,2,60,48,4,2000,-1:-1,hex,crop,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"