#!/bin/sh

numb='2449'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 30 --keyint 260 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.0,1.3,1.3,1.6,0.3,0.9,0.4,2,0,10,30,260,0,23,10,4,3,62,18,4,1000,-1:-1,umh,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"