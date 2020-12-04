#!/bin/sh

numb='1907'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 20 --keyint 200 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.1,1.1,1.4,0.4,0.9,0.8,1,0,4,20,200,3,30,10,3,2,65,18,3,1000,1:1,umh,crop,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"