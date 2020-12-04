#!/bin/sh

numb='1336'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 10 --keyint 290 --lookahead-threads 1 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.6,1.1,4.8,0.4,0.9,0.6,2,1,10,10,290,1,21,50,4,3,68,48,4,2000,1:1,dia,crop,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"