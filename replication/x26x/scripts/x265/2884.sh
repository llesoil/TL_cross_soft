#!/bin/sh

numb='2885'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 5 --keyint 260 --lookahead-threads 3 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.2,1.2,1.0,0.2,0.7,0.2,2,2,10,5,260,3,30,50,4,3,69,28,6,2000,1:1,dia,show,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"