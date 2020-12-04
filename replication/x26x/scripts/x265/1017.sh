#!/bin/sh

numb='1018'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 5 --keyint 200 --lookahead-threads 0 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.1,1.1,0.4,0.6,0.6,0.6,3,1,14,5,200,0,27,40,3,3,67,18,5,1000,-2:-2,dia,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"