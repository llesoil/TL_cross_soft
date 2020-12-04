#!/bin/sh

numb='892'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 25 --keyint 270 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.1,1.2,1.6,0.6,0.6,0.6,1,0,10,25,270,3,26,10,3,2,65,38,5,2000,1:1,umh,show,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"