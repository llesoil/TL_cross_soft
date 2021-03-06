#!/bin/sh

numb='171'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 15 --keyint 300 --lookahead-threads 3 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.0,1.3,3.6,0.4,0.9,0.7,0,1,12,15,300,3,28,20,3,4,61,28,3,1000,-1:-1,umh,show,fast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"