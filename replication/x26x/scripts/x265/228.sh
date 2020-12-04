#!/bin/sh

numb='229'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 0 --keyint 280 --lookahead-threads 0 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.5,1.3,1.4,0.4,0.4,0.7,0.7,2,1,2,0,280,0,29,50,3,0,61,48,2,2000,-1:-1,umh,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"