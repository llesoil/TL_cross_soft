#!/bin/sh

numb='2435'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 40 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.3,1.2,3.0,0.6,0.6,0.9,1,0,8,40,210,2,22,30,3,4,63,38,4,2000,1:1,umh,show,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"