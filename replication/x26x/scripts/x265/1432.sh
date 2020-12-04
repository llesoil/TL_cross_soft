#!/bin/sh

numb='1433'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 0.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 35 --keyint 270 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.3,1.0,0.4,0.6,0.7,0.0,1,2,6,35,270,4,29,0,3,4,62,28,3,1000,-1:-1,umh,crop,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"