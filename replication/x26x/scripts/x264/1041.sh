#!/bin/sh

numb='1042'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 0 --crf 10 --keyint 210 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.0,1.4,3.6,0.4,0.6,0.4,0,0,0,10,210,1,24,10,3,1,66,18,5,1000,-1:-1,umh,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"