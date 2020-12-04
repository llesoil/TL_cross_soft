#!/bin/sh

numb='2825'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 45 --keyint 230 --lookahead-threads 2 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.0,1.2,2.0,0.2,0.7,0.0,0,0,8,45,230,2,27,50,4,2,61,38,4,1000,-1:-1,umh,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"