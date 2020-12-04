#!/bin/sh

numb='3082'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 10 --keyint 250 --lookahead-threads 2 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.5,1.0,1.0,3.8,0.4,0.7,0.3,2,2,0,10,250,2,30,30,3,0,61,18,1,2000,-1:-1,dia,crop,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"