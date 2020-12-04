#!/bin/sh

numb='2092'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 30 --keyint 250 --lookahead-threads 4 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.6,1.2,1.2,0.5,0.9,0.8,1,2,10,30,250,4,30,40,5,0,63,38,5,1000,1:1,hex,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"