#!/bin/sh

numb='23'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 35 --keyint 260 --lookahead-threads 4 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.0,2.0,0.4,0.9,0.9,1,0,6,35,260,4,24,10,3,0,65,18,5,1000,-1:-1,umh,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"