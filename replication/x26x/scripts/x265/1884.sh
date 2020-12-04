#!/bin/sh

numb='1885'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 10 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.4,1.4,2.2,0.5,0.8,0.4,1,0,8,10,260,2,28,10,4,4,65,18,4,2000,-1:-1,hex,crop,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"