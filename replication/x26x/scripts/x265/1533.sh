#!/bin/sh

numb='1534'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 10 --keyint 210 --lookahead-threads 2 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.0,1.0,1.3,2.8,0.6,0.8,0.0,0,0,10,10,210,2,20,40,5,4,66,28,1,1000,-1:-1,hex,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"