#!/bin/sh

numb='7'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 35 --keyint 260 --lookahead-threads 1 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.3,1.0,4.0,0.3,0.9,0.8,3,0,2,35,260,1,24,0,4,0,61,48,4,2000,-1:-1,dia,crop,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"