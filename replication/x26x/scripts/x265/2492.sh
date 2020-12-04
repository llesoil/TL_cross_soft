#!/bin/sh

numb='2493'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 10 --keyint 300 --lookahead-threads 0 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,None,--no-weightb,0.5,1.1,1.0,0.8,0.2,0.7,0.0,1,1,16,10,300,0,21,20,3,2,64,28,1,1000,-1:-1,dia,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"