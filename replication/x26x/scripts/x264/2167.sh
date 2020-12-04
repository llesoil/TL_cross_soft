#!/bin/sh

numb='2168'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 25 --keyint 200 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.1,1.4,1.2,0.5,0.6,0.1,1,1,0,25,200,0,25,0,4,2,64,28,3,1000,-2:-2,dia,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"