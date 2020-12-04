#!/bin/sh

numb='2458'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --intra-refresh --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 25 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,None,--no-weightb,0.5,1.4,1.3,0.4,0.2,0.7,0.8,2,1,16,25,220,2,26,40,3,3,64,48,1,1000,-1:-1,umh,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"