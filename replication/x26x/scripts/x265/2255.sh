#!/bin/sh

numb='2256'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 20 --keyint 290 --lookahead-threads 2 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.0,1.2,1.8,0.6,0.7,0.6,1,0,2,20,290,2,27,0,5,4,68,48,5,1000,1:1,umh,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"