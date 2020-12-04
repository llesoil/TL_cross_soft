#!/bin/sh

numb='1297'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 10 --keyint 260 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.6,1.2,2.2,0.3,0.7,0.1,0,1,10,10,260,1,27,30,5,4,62,18,1,1000,-1:-1,dia,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"