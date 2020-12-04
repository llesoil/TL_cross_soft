#!/bin/sh

numb='2676'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 0.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 20 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.3,1.2,0.6,0.5,0.6,0.6,1,1,0,20,300,3,24,10,3,2,68,38,5,1000,-1:-1,umh,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"