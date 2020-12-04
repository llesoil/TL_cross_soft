#!/bin/sh

numb='881'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 40 --keyint 210 --lookahead-threads 1 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.1,1.2,0.4,0.5,0.8,0.1,0,2,14,40,210,1,29,0,5,2,68,18,1,2000,-1:-1,umh,crop,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"