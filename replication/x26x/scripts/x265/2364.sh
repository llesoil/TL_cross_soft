#!/bin/sh

numb='2365'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 30 --keyint 300 --lookahead-threads 3 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.1,1.1,4.4,0.6,0.6,0.7,3,0,10,30,300,3,26,50,5,4,67,28,2,2000,-1:-1,dia,show,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"