#!/bin/sh

numb='1942'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 45 --keyint 280 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.0,1.1,3.4,0.3,0.7,0.0,3,1,10,45,280,1,26,20,3,4,61,28,3,2000,1:1,umh,show,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"